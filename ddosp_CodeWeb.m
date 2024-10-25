%---------------------------------------------------------------------------
%  Data-Driven Learning of MRI Sampling Pattern
%---------------------------------------------------------------------------
%   Recon results from DDOSP using STFD Recon
%   Rajiv Menon, 2021
%---------------------------------------------------------------------------

%select data to work with
dataname='Sample_Data';

dataroot='/xx/datapath';
datadir=[dataroot dataname '/2_Data/'];

%Code stored here
basedir=['/xx/datapath/' dataname '/1_Code/'];
cd(basedir);
addpath(genpath([basedir dataname '/1_Code/']));

load([datadir 'kdata/T1rho_TSL_pos_dim.mat'],'par');
disp(['data set: ' dataname]);
disp(['data dimensions - [N_x N_y N_t N_c] = [' num2str(par.pos_dim) ']']);
disp(['relaxation times - TSLs (ms) = ' num2str(par.TSL)]);

meth= 'STFD';
rmethod= ['recon_' meth]; %change here to a different CS method

recon_slices = [21 22 23 24 25 31 32 33 34 35];
accels=[2 4 6 8 10 15 20 25 30];
%ac=9;
ac=str2num(getenv('SLURM_ARRAY_TASK_ID'));

param.use_gpu=0;                %option to use GPU
plot_figs=0;                    %plot intermediate results
optim_train=1;                  %use reg. parameter for optimized mask or  for initial mask
generate_SP=0;                  %use generated SP or load file
SP_type_initial='var_dens';  %poi_disk var_dens rad_GAng AL1_rand out_rand only__in greedy full_sam
SP_type='var_dens';          %poi_disk var_dens rad_GAng AL1_rand out_rand only__in greedy full_sam
N=prod(par.pos_dim(1:3));           %par.dim(1:3)=N_x x N_y x N_t
M=floor(N/accels(ac));
K_init=200;                   %Initial K used for learning SP
NN=5;                        %number of images used for training

%%
%reconstruction configuration
if(param.use_gpu), gpu = gpuDevice(1); end
param.T =  FD_ST(1,2,4,param.use_gpu);
meth='STFD';
recon_STFD.meth=meth;
disp([' ']);
disp(['Sampling Mask Optimization for method: ' meth ' with AF: ' num2str(accels(ac)) ' for One-frame and Multi-coil MRI' ]);

%CS reconstruction using MFISTA-VA-FGP
param.ar=264;
param.maxfgp=25;
param.initfgp=7;
param.c=1;
param.nite = 150;
param.display=0;
param.mu=1.5;
param.comp_cost=0;
param.errorTol=1e-6;
param.restart=0;
param.backtracking=0;
param.optimized=0;
param.backstep=1.05;

accel=accels(ac);
% if(optim_train)
%     load([datadir 'recon_STFD/lambda_STFD_optim.mat'],'lambda_accel_w');
% else
%     load([datadir 'recon_STFD/lambda_STFD_' SP_type '.mat'],'lambda_accel_w');
% end
% if(param.use_gpu), lambda_accel_w=gpuArray(lambda_accel_w); else lambda_accel_w=gather(lambda_accel_w); end
% param.lambda_S=lambda_accel_w(accel);
% param.lambda_L=0;

%% Basic undersampling
N=length(recon_slices);
slices=(recon_slices);

clear  f v_f g v_g g_ssim v_g_ssim partial_epsilon partial_r partial_m;

for iter=1:2
    if(iter==1)
        disp(['Working with initial SP, based on: ' SP_type_initial]);
        
        load([datadir 'recon_' meth '/lambda_' meth '_' SP_type_initial '.mat'],'lambda_accel_w');
        
        if(param.use_gpu), lambda_accel_w=gpuArray(lambda_accel_w); 
        else lambda_accel_w=gather(lambda_accel_w); end
        param.lambda_S=lambda_accel_w(ac);
        param.lambda_L=0;
        
        load([datadir 'sampling_pattern/sample_mask_CS_' meth '_A' num2str(accel) '_init_' SP_type_initial ...
            '_K'  num2str(K_init) '_N'  num2str(NN) '.mat'],...
            'SP_Omega','SP_Omega_initial','accel','real_accel');
        SP_Omega=SP_Omega_initial;
        
    elseif(iter==2)
        disp(['Working with optimized SP, with initial SP: ' SP_type]);
        
        if(optim_train)
            load([datadir 'recon_STFD/lambda_' meth '_optim.mat'],'lambda_accel_w');
        else
            load([datadir 'recon_STFD/lambda_' meth '_' SP_type '.mat'],'lambda_accel_w');
        end
        if(param.use_gpu), lambda_accel_w=gpuArray(lambda_accel_w); else lambda_accel_w=gather(lambda_accel_w); end
        param.lambda_S=lambda_accel_w(ac);
        param.lambda_L=0;
        
        load([datadir 'sampling_pattern/sample_mask_CS_' meth '_A' num2str(accel) '_init_' SP_type ...
            '_K'  num2str(K_init) '_N'  num2str(NN) '.mat'],...
            'SP_Omega','SP_Omega_initial','accel','real_accel');
    end
    disp([' ']);
    
    if(plot_figs), figure(3), imshow3(SP_Omega_initial,[],[2 5]);  title(['Initial SP']); end
    
    for i=1:N
        
        slice=slices(i);
        disp(['Working with set: ' dataname ', and slice: ' num2str(slice) ]);
        
        load([datadir 'recon_' meth '/T1rho_images' num2str(slice) '.mat'],'images');
        load([datadir 'kdata/T1rho_data' num2str(slice) '.mat'],'data');
        load([datadir 'coilmap/T1rho_coilmap' num2str(slice) '.mat'],'coilmap');
        
        if(param.use_gpu)
            param.x_exact=gpuArray(images);
            m_i=gpuArray(data);
            coilmap=gpuArray(coilmap);
        else
            param.x_exact=images;
            m_i=data;
        end
        x=images;
        
        %Creating CS matrix
        param.B = Emat_xyt(ones(par.pos_dim(2:4)),coilmap,param.use_gpu);
        param.E = Emat_xyt(SP_Omega,coilmap,param.use_gpu);
        param.m = m_i;
        
        recon_fft=param.E'*param.m; % undersampling happens here!
        
        %Reconstruction info in recon structure
        recon_STFD.accel=accel;
        recon_STFD.slice=slice;
        recon_STFD.im=recon_fft;
        
        tic;
        [recon_STFD] = L2_LpS_MFISTA_FGP_VA(recon_STFD,param);
        toc;
        
        xr_i=gather(recon_STFD.im);
        mr_i=gather(param.B*recon_STFD.im);
        m_i=gather(m_i);
        Emmr_i=m_i-mr_i;
        
        E_i=sqrt(sum(abs(Emmr_i).^2,4));
        r_i=sqrt(sum(((abs(Emmr_i)+eps)./(abs(m_i)+eps)).^2,4));
        m_i=sqrt(sum(abs(m_i).^2,4));
        e_i=x(:)-xr_i(:);
        
        if(plot_figs),
            figure, imshow3(abs(xr_i),[0 .7*max(abs(xr_i(:)))],[2,5]); 
            title(['reconstruction slice: ' num2str(slice) ]);
            figure, imshow3(abs(x-xr_i),[0 .5*max(abs(e_i(:)))],[2,5]);
            title(['image error slice: ' num2str(slice) ]);
            drawnow;
        end
        
        %% save images
        if(iter==1)
            img_poi=imrotate(abs(xr_i),-90);img_ref=imrotate(abs(x),-90);
            filenm=['ReconIm_' dataname '_Meth' meth '_Slice'  num2str(slice) '_AF' num2str(accel) '_SP' SP_type];
            save([datadir 'Recon_Display/' filenm '.mat'],'img_poi','img_ref');
        elseif(iter==2)
            img_optim=imrotate(abs(xr_i),-90);img_ref=imrotate(abs(x),-90);
            filenm=['ReconIm_' dataname '_Meth' meth '_Slice'  num2str(slice) '_AF' num2str(accel) '_SPoptim' ];
            save([datadir 'Recon_Display/' filenm '.mat'],'img_optim','img_ref');
        end
        
        if(i<=N)
            partial_epsilon(:,i)=E_i(:);
            partial_r(:,i)=r_i(:);
            partial_m(:,i)=m_i(:);
            
            %error f
            f(i,iter)=norm(Emmr_i(:),2).^2/norm(m_i(:),2).^2;
            %error f
            g(i,iter)=norm(e_i(:),2).^2/norm(images(:),2).^2;
            %experimental
            g_ssim(i,iter)=(ssim(real(xr_i),real(x))+ssim(imag(xr_i),imag(x)))/2;%ssim(abs(xr_i),abs(x))
        end
        
    end
end
