clear all
clc
noc=50; %no_of_classes 50
% thrY=15.37545;
% thrU=49.5159;
% thrV=46.74;
% thrM=37.21045; % added all thrYUV and divided by 3
% load histograms
% load HistogramF
load Hist_ESSEX_HR_ND_500
% load HistFeretYUV2
% load histofwholeface
%pp=H;
for i=1:500 %500 %number of images
    ppY(i,:)=double(Y(i,:)/sum(Y(i,:)));
    ppU(i,:)=double(U(i,:)/sum(U(i,:)));
    ppV(i,:)=double(V(i,:)/sum(V(i,:)));
end
% return;
zeta=1;
clear memory
tic
clear eps
for q=1:50
    fprintf('q = %d\n', q);

    r=randperm(10);
    %%%%%%%%%%%%%%%%%%%%
    for w=1:9 % number of training faces in each class is changing from 1 to 9
        fprintf('w = %d\n', w);
            % if 10, then all the images are in training
        %s1=0;
        sY=0;
        sU=0;
        sV=0;
        sBS=0;
        sM=0;
        
%         sY2=0; % counters for the second best distance
%         sU2=0;
%         sV2=0;
%         sBS2=0;
%         sM2=0;
        
%         wrongY = 0; %counter for when the first match is wrong
%         wrongU = 0;
%         wrongV = 0;
%         correctY = 0; %counter for when the secong match is correct
%         correctU = 0;
%         correctV = 0;
        
        for i=1:noc
%             fprintf('i = %d\n', i);
            for j=1:w %training images
                %train1(((i-1)*10+j),:)=(pp(((i-1)*10+r(j)),:));
                trainY(((i-1)*10+j),:)=(ppY(((i-1)*10+r(j)),:));
                trainU(((i-1)*10+j),:)=(ppU(((i-1)*10+r(j)),:));
                trainV(((i-1)*10+j),:)=(ppV(((i-1)*10+r(j)),:));
                clear Memory
            end
            nj=1;
            for j=w+1:10 % test images
                %test(((i-1)*10+nj),:)=(pp(((i-1)*10+r(j)),:));
                testY(((i-1)*10+nj),:)=(ppY(((i-1)*10+r(j)),:));
                testU(((i-1)*10+nj),:)=(ppU(((i-1)*10+r(j)),:));
                testV(((i-1)*10+nj),:)=(ppV(((i-1)*10+r(j)),:));
                nj=nj+1;
                clear Memory
            end
        end
        zz=1;
        clear Memory
        gc=1;
        for i=1:noc
            for j=1:10-w
                cnt=1;
                for k=1:noc
                    for h=1:w 
                        %dist1(cnt)=sum((test(((i-1)*10+j),:)).*log10((1e-6+test(((i-1)*10+j),:))./(1e-6+train1(((k-1)*10+h),:))));
                        distY(cnt)=sum((testY(((i-1)*10+j),:)).*log10((1e-6+testY(((i-1)*10+j),:))./(1e-6+trainY(((k-1)*10+h),:))));
                        distU(cnt)=sum((testU(((i-1)*10+j),:)).*log10((1e-6+testU(((i-1)*10+j),:))./(1e-6+trainU(((k-1)*10+h),:))));
                        distV(cnt)=sum((testV(((i-1)*10+j),:)).*log10((1e-6+testV(((i-1)*10+j),:))./(1e-6+trainV(((k-1)*10+h),:))));
    %                     dist1(cnt)=sqrt(sum((train1(((k-1)*10+h),:)-pp(((i-1)*10+j),:)).^2));
                        cnt=cnt+1;
                        clear memory
                    end
                end
                %[Minimum_Error holder]=min(dist1);
                [distYs distYpos]=sort(distY);
                [distUs distUpos]=sort(distU);
                [distVs distVpos]=sort(distV);
                
%                 distYs=distYs/sum(distYs);
%                 distUs=distUs/sum(distUs);
%                 distVs=distVs/sum(distVs);
                
                Minimum_ErrorY=distYs(1); holderY= distYpos(1);
                Minimum_ErrorU=distUs(1); holderU=distUpos(1);
                Minimum_ErrorV=distVs(1); holderV= distVpos(1);
                
%                 [Minimum_ErrorY holderY]=min(distY);
%                 [Minimum_ErrorU holderU]=min(distU);
%                 [Minimum_ErrorV holderV]=min(distV);


                [minVal minLoc]=min([Minimum_ErrorY Minimum_ErrorU Minimum_ErrorV]);
                
%                 distY2 = distY(distY~=min(distY));%distance vector after removing the minimum value
%                 distU2 = distU(distU~=min(distU));
%                 distV2 = distV(distV~=min(distV));
%                 [Minimum_ErrorY2 holderY2]=min(distY2);
%                 [Minimum_ErrorU2 holderU2]=min(distU2);
%                 [Minimum_ErrorV2 holderV2]=min(distV2);

%                 Minimum_ErrorY2=distYs(2); holderY2= distYpos(2); %second best distance
%                 Minimum_ErrorU2=distUs(2); holderU2=distUpos(2);
%                 Minimum_ErrorV2=distVs(2); holderV2= distVpos(2);
%                 [minVal2 minLoc2]=min([Minimum_ErrorY2 Minimum_ErrorU2 Minimum_ErrorV2]);
%                 myvar{w}{i}{j}{k}=[Minimum_ErrorY2 Minimum_ErrorU2 Minimum_ErrorV2];

                if minLoc==1
                    holder=holderY;
                else if minLoc==2
                        holder=holderU;
                    else
                        holder=holderV;
                    end
                end
                

%                 if ceil(holder/w)==ceil(gc/(10-w))
%                     sBS=sBS+1;
%                 end
                
                if (ceil(holderY/w)==ceil(gc/(10-w)))% && (Minimum_ErrorY<thrY))
                    sY=sY+1;  
                end
                if (ceil(holderU/w)==ceil(gc/(10-w)))% && (Minimum_ErrorU<thrU))
                    sU=sU+1;
                end
                if (ceil(holderV/w)==ceil(gc/(10-w)))% && (Minimum_ErrorV<thrV))
                    sV=sV+1;
                end
                
                me=[Minimum_ErrorY Minimum_ErrorU Minimum_ErrorV];
                mvv=[ceil(holderU/w) ceil(holderV/w) ceil(holderY/w)];
                [majVal maj]=mode(mvv);
                if maj==1                                                           
                    if (ceil(holder/w)==ceil(gc/(10-w)))% && (me(minLoc)<thrM))  
                        sM=sM+1;
                    end
                else
                    temp=find(mvv==majVal);
                    if (majVal==(ceil(gc/(10-w))))% && me(temp(1))<thrM)
                        sM=sM+1;
                    end
                end
                
%                 %here starts the same as before but for second best
%                 %distances
%                 if minLoc2==1
%                     holder2=holderY2;
%                 else if minLoc2==2
%                         holder2=holderU2;
%                     else
%                         holder2=holderV2;
%                     end
%                 end
%                 
%                 if ceil(holder2/w)==ceil(gc/(10-w))
%                     sBS2=sBS2+1;
%                 end
%                 if ceil(holderY2/w)==ceil(gc/(10-w))
%                     sY2=sY2+1;    
%                 end
%                 if ceil(holderU2/w)==ceil(gc/(10-w))
%                     sU2=sU2+1;
%                 end
%                 if ceil(holderV2/w)==ceil(gc/(10-w))
%                     sV2=sV2+1;
%                 end
%                 [majVal2 maj2]=mode([ceil(holderU2/w) ceil(holderV2/w) ceil(holderY2/w)]);
%                 if maj2==1
%                     if ceil(holder2/w)==ceil(gc/(10-w))
%                         sM2=sM2+1;
%                     end
%                 else
%                     if majVal2==ceil(gc/(10-w))
%                         sM2=sM2+1;
%                     end
%                 end
                
                
                gc=gc+1;
            end
            clear memory
            zz=zz+w;
        end
    %     R1=100*s1/(noc*(10-w));   
        RY=100*sY/(noc*(10-w));
        RU=100*sU/(noc*(10-w));
        RV=100*sV/(noc*(10-w));
%         RBS=100*sBS/(noc*(10-w));
        RM=100*sM/(noc*(10-w));
        
        
%         RY2=100*sY2/(noc*(10-w)); %second best distance
%         RU2=100*sU2/(noc*(10-w));
%         RV2=100*sV2/(noc*(10-w));
%         RBS2=100*sBS2/(noc*(10-w));
%         RM2=100*sM2/(noc*(10-w));
        
        
        
    %     RES1(w)=R1;
        RESY(w)=RY;
        RESU(w)=RU;
        RESV(w)=RV;
%         RESBS(w)=RBS;
        RESM(w)=RM;
        
%         RESY2(w)=RY2; % second best distance
%         RESU2(w)=RU2;
%         RESV2(w)=RV2;
%         RESBS2(w)=RBS2;
%         RESM2(w)=RM2;
        
        clear RY RU RV RBS RM RY2 RU2 RV2 RBS2 RM2
    end
    REY(q,:)=RESY
    REU(q,:)=RESU
    REV(q,:)=RESV
%     REB(q,:)=RESBS
    REM(q,:)=RESM
    
%     REY2(q,:)=RESY2 %second best distance
%     REU2(q,:)=RESU2
%     REV2(q,:)=RESV2
%     REB2(q,:)=RESBS2
%     REM2(q,:)=RESM2
    clear r gc R1 s1 dist1 zz w RES1 train1 test
    clear trainY trainU trainV TestY testU testV distY distU distV
    clear sY sU sV RESY RESU RESV REBS RESM
    
%     clear distY2 distU2 distV2 sY2 sU2 sV2 RESY2 RESU2 RESV2 RESBS2
%     RESM2
%     %second best distance
%     
%%%%%%%%%%%%%%%%%%%%

end;

% secondCY = (correctY/wrongY)*100 %from the times that first guess is wrong how often is the secong guess correct
% secondCU = (correctU/wrongU)*100
% secondCV = (correctV/wrongV)*100
%FR=mean(R)
FRY=mean(REY)
FRU=mean(REU)
FRV=mean(REV)
% FRBS=mean(REB)
FRM=mean(REM)

% FRY2=mean(REY2) %second best distance
% FRU2=mean(REU2)
% FRV2=mean(REV2)
% FRBS2=mean(REB2)
% FRM2=mean(REM2)

toc
[FRY' FRU' FRV' FRM']