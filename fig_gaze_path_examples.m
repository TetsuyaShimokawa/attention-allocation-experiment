function fig_gaze_path_examples

% data import
load Subject Subject 

%The signal sequence for path6 is [0.1,0.3,0.5,0.7,-0.1,-0.3,-0.5,-0.7], so we have to correct it
for s_id=[1,4]
    path_id=6;
    gaze_dist(:,1)=Subject(s_id).Path(path_id).gaze_dist(:,8);
    gaze_dist(:,2)=Subject(s_id).Path(path_id).gaze_dist(:,7);
    gaze_dist(:,3)=Subject(s_id).Path(path_id).gaze_dist(:,6);
    gaze_dist(:,4)=Subject(s_id).Path(path_id).gaze_dist(:,5);

    gaze_dist(:,5)=Subject(s_id).Path(path_id).gaze_dist(:,4);
    gaze_dist(:,6)=Subject(s_id).Path(path_id).gaze_dist(:,3);
    gaze_dist(:,7)=Subject(s_id).Path(path_id).gaze_dist(:,2);
    gaze_dist(:,8)=Subject(s_id).Path(path_id).gaze_dist(:,1);
    
    for cp=1:length(gaze_dist(:,1))
        gaze_dist_ratio(cp,:)=gaze_dist(cp,:)./nansum(gaze_dist(cp,:));
    end

    figure
    bar(gaze_dist_ratio,'stacked')
    legend('β = -0.7','β = -0.5','β = -0.3','β = -0.1','β = 0.7','β = 0.5','β = 0.3','β = 0.1')
    ylim([0 1])
    ylabel('Gaze ratio')
    xlabel('Periods')

    
    clear gaze_dist_ratio gaze_dist_ratio10
    
end
