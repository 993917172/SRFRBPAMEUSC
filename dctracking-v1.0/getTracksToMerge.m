function stateInfo=getTracksToMerge(stateInfo)

asscDet = stateInfo.asscDet;

[F,N]=size(asscDet);
X_new = zeros(F,N);
Y_new = zeros(F,N);
Xi_new = zeros(F,N);
Yi_new = zeros(F,N);
asscDet_new = zeros(F,N);
H_new = zeros(F,N);
W_new = zeros(F,N);
stateInfo.mergeWithId = zeros(1,N);
targetsExist=getTracksLifeSpans(asscDet);

new_id = 1; % new id of track
for id1=1:N % for each track
    sid1=targetsExist(id1,1); % start frame of track
    eid1=targetsExist(id1,2); % end frame of track
    
    foundTrackToMerge = 0;
    for id2=(id1+1):N % for each next track
        sid2=targetsExist(id2,1); % start frame of compared track
        eid2=targetsExist(id2,2); % end frame of comared track
        frames = 0; % overlapping frames
        if sid1 < sid2 && sid2 < eid1 && eid1 < eid2 
            % id1 starts first and ends first
            frames = sid2:eid1; 
        elseif sid2 < sid1 && sid1 < eid2 && eid2 < eid1 
            % id2 starts first and ends first
            frames = sid1:eid2;
        elseif sid1 < sid2 && eid1 > eid2 
            % id1 starts first and ends last
            frames = sid2:eid2;
        elseif sid1 > sid2 && eid1 < eid2 
            % id2 starts first and ends last
            frames = sid1:eid1;
        end
        sameDetCount = 0;
        % count matching detections
        if frames > 0
            for t=frames
                if asscDet(t,id1) == asscDet(t,id2)
                    sameDetCount = sameDetCount + 1;
                end
            end
        end
        % if all detections are same and track hasn't been merged
        % already. Then merge tracks id1 and id2
        if sameDetCount == length(frames) && ...
                stateInfo.mergeWithId(id1) == 0
            foundTrackToMerge = 1;
            stateInfo.mergeWithId(id2) = id1; % write down merged id
            X_new(sid1:eid1,new_id) = stateInfo.X(sid1:eid1,id1);
            X_new(sid2:eid2,new_id) = stateInfo.X(sid2:eid2,id2);
            Y_new(sid1:eid1,new_id) = stateInfo.Y(sid1:eid1,id1);
            Y_new(sid2:eid2,new_id) = stateInfo.Y(sid2:eid2,id2);
            Xi_new(sid1:eid1,new_id) = stateInfo.Xi(sid1:eid1,id1);
            Xi_new(sid2:eid2,new_id) = stateInfo.Xi(sid2:eid2,id2);
            Yi_new(sid1:eid1,new_id) = stateInfo.Yi(sid1:eid1,id1);
            Yi_new(sid2:eid2,new_id) = stateInfo.Yi(sid2:eid2,id2);
            asscDet_new(sid1:eid1,new_id) = stateInfo.asscDet(sid1:eid1,id1);
            asscDet_new(sid2:eid2,new_id) = stateInfo.asscDet(sid2:eid2,id2);
            H_new(sid1:eid1,new_id) = stateInfo.H(sid1:eid1,id1);
            H_new(sid2:eid2,new_id) = stateInfo.H(sid2:eid2,id2);
            W_new(sid1:eid1,new_id) = stateInfo.W(sid1:eid1,id1);
            W_new(sid2:eid2,new_id) = stateInfo.W(sid2:eid2,id2);
        % if all detections are same and track has been merged already
        % then merge id2 with track, that id1 has already been merged with
        elseif sameDetCount == length(frames) && ...
                stateInfo.mergeWithId(id1) ~= 0
            alreadyMergedWith = stateInfo.mergeWithId(id);
            stateInfo.mergeWithId(id2) = alreadyMergedWith; % write down merged id
            X_new(sid1:eid1,alreadyMergedWith) = stateInfo.X(sid2:eid2,id2);
            Y_new(sid1:eid1,alreadyMergedWith) = stateInfo.Y(sid2:eid2,id2);
            Xi_new(sid1:eid1,alreadyMergedWith) = stateInfo.Xi(sid2:eid2,id2);
            Yi_new(sid2:eid2,alreadyMergedWith) = stateInfo.Yi(sid2:eid2,id2);
            asscDet_new(sid2:eid2,alreadyMergedWith) = stateInfo.asscDet(sid2:eid2,id2);
            H_new(sid2:eid2,alreadyMergedWith) = stateInfo.H(sid2:eid2,id2);
            W_new(sid2:eid2,alreadyMergedWith) = stateInfo.W(sid2:eid2,id2);
        end
        
    end
    % if track doesn't need merging, then move track as is 
    if foundTrackToMerge == 0
        X_new(:,new_id) = stateInfo.X(:,id1);
        Y_new(:,new_id) = stateInfo.Y(:,id1);
        Xi_new(:,new_id) = stateInfo.Xi(:,id1);
        Yi_new(:,new_id) = stateInfo.Yi(:,id1);
        asscDet_new(:,new_id) = stateInfo.asscDet(:,id1);
        H_new(:,new_id) = stateInfo.H(:,id1);
        W_new(:,new_id) = stateInfo.W(:,id1);
    end
    % If track hasn#t been merged, then increase new id
    if stateInfo.mergeWithId(id1) == 0
        new_id = new_id + 1;
    end
end
% Remove extra columns
X_new( :, all( ~any(X_new ), 1 ) ) = [];
Y_new( :, all( ~any(Y_new ), 1 ) ) = [];
Xi_new( :, all( ~any(Xi_new ), 1 ) ) = [];
Yi_new( :, all( ~any(Yi_new ), 1 ) ) = [];
asscDet_new( :, all( ~any(asscDet_new ), 1 ) ) = [];
H_new( :, all( ~any(H_new ), 1 ) ) = [];
W_new( :, all( ~any(W_new ), 1 ) ) = [];

% overwrite old tracks with new
stateInfo.X = X_new;
stateInfo.Y = Y_new;
stateInfo.Xi = Xi_new;
stateInfo.Yi = Yi_new;
stateInfo.asscDet = asscDet_new;
stateInfo.H = H_new;
stateInfo.W = W_new;

