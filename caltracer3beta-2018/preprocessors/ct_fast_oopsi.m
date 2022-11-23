function x = ct_fast_oopsi(x, handles, options)
% This function prepares and runs fast oopsi on the traces as a
% preprocessor in caltracer.

rawF=x;
Ncells = size(rawF,1);

V.dt=handles.app.experiment.timeRes;
P.lam=options.Plam.value;
V.posspiketimes = 500:options.brpoints.value:size(rawF,2);
tau=.8;
P.gam = (1-V.dt/tau)';
P.a = 1.5;

spikes = cell(size(rawF,1),1); % spike inference output vector
struct = cell(size(rawF,1),1); % spike inference output struct
indices = ones(size(rawF,1),1);
n = zeros(size(rawF,2),1);
x = zeros(size(rawF));

% %------added for dF/dFo------
% time_res = options.timeRes.value;
% frequency = 1/time_res;
% tau1 = round(frequency*.75);
% tau2 = round(frequency*3);
% offset = tau2+tau1/2+1;
% %-----end added for dF/dFo-------


for i = 1:size(rawF, 1)
%     fprintf('\nneuron %d\n',i);
%     Fcell = rawF(i,:);
% 
% 
% %     transposed = transpose(Fcell);
% %     smoothed = smooth(transposed,options.smoothing.value);
% %     Fcell = transpose(smoothed);
%     %Fcell = detrend(Fcell,'linear',V.posspiketimes);
%     %Fcell=Fcell-min(Fcell); Fcell=Fcell/max(Fcell); Fcell=Fcell+eps;
% 
%         %-------begin dF/Fo----------
%     Fcell_updated = zeros(size(Fcell));
%     %Fcell_updated = Fcell;
%     [num_neurons, num_frames]=size(rawF);
%   
%     for t=offset:(num_frames-tau1/2)
%         minimum = Inf;
%         for y = (t-tau2):t
%             integral = 0;
%             for tauvar=(y-tau1/2):(y+tau1/2)
%                 integral = integral+Fcell(tauvar);%rawF(i,tauvar);
%             end
%             integral = 1/tau1*integral;
%             minimum = min(minimum,integral);
%         end
%         Fo = minimum;
%         Ft = Fcell(t);
%         Fcell_updated(t) = (Ft/Fo)-1;
%         
%     end
%     
%     Fcell_updated = detrend(Fcell_updated,'linear',V.posspiketimes);
%     
%     transposed = transpose(Fcell_updated);
%     smoothed = smooth(transposed,options.smoothing.value);
%     Fcell_updated = transpose(smoothed);
%     
%     Fcell_updated=Fcell_updated-min(Fcell_updated); Fcell_updated=Fcell_updated/max(Fcell_updated); Fcell_updated=Fcell_updated+eps;
%     %rawF(i,:) = Fcell_updated;
%     %x(i,:)=rawF(i,:);
%     P.b = median(Fcell_updated);
% %------
    
   fprintf('running spike inference...\n');
    
    [n, test.P, test.V]= fast_oopsi(rawF(i,:),V,P);
        
        struct{i}.P = test.P;
        struct{i}.n = n;
        spikes{i}=struct{i}.n;
%         spikes{i}=spikes{i}/max(spikes{i});
        x(i,:)=spikes{i};
        V.F{i}=rawF(i,:);   
end


