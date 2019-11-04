%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Vanderbilt Chest X-ray Test
% 07/2017 by Mackenzie Sunday
% Set the Screen to 1024x768 resolution.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = VCRT(subjno,subjini,age,sex,hand)
try
    commandwindow;  
    
    key1 = KbName('1!'); key2 = KbName('2@'); key3 = KbName('3#');
    key4 = KbName('4$'); key5 = KbName('5%'); key6 = KbName('6^');
    key7 = KbName('7&'); key8 = KbName('8*'); key9 = KbName('9(');
    spaceBar = KbName('space');
    
    wrongkey=MakeBeep(700,0.1);
    
    % setting up keyboards
    devices = PsychHID('Devices');
    kbs = find([devices(:).usageValue] == 6);
    usethiskeyboard = kbs(end);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % imfolder = 'VCXTimages';
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    fdbktime = 1;  %time the feedback is displayed for
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Open Screens.
    bcolor=0;    
    AssertOpenGL;
    ScreenNumber=max(Screen('Screens'));
    [w, ScreenRect]=Screen('OpenWindow',ScreenNumber, bcolor, [], 32, 2);
    white=WhiteIndex(w); %get white value
    midWidth=round(RectWidth(ScreenRect)/2);   
    midLength=round(RectHeight(ScreenRect)/2);
    Screen('FillRect', w, [255 255 255]); % set scrren to white
    Screen('Flip',w);
    Priority(MaxPriority(w));
    
    Screen_X = RectWidth(ScreenRect); 
    Screen_Y = RectHeight(ScreenRect); 
    cx = round(Screen_X/2);
    cy = round(Screen_Y/2);
    
    ScreenBlank = Screen(w, 'OpenOffScreenWindow', white, ScreenRect);
    [oldFontName, oldFontNumber] = Screen(w, 'TextFont', 'Helvetica' ); %set font
    [oldFontName, oldFontNumber] = Screen(ScreenBlank, 'TextFont', 'Helvetica' );
    oldFontSize=Screen(w,'TextSize',[40]); %set text size
    
    %Open data file.
    oldfolder = cd; %gets the main folder filepath
    cd('VCRT_data') %changes current directory to data file
    fileName1 = ['VCRT_' num2str(subjno) '_' subjini '.txt'];
    dataFile = fopen(fileName1, 'w');
    cd('..'); %changes the current directory back to the main folder
    
    ListenChar(2);
    HideCursor;
    commandwindow;
    
    fprintf(dataFile, '%20s\t%20s\n','time',mat2str(fix(clock)));
    fprintf(dataFile,'\nsubjno\tsubjini\tage\tsex\thand\tsession');
    fprintf(dataFile, '\n%s\t%s\t%s\t%s\t%s',subjno,subjini,age,sex,hand);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fprintf(dataFile, ['\nsubjno\tsubjini\ttrialnum\tfdbkdisp\trespdisp\ttarloc\tresp\tac\trt']); %prints headers
    
    startexpt = GetSecs; %get time of the start of the experiment
        
    fixation = uint8(ones(7)*255);
    fixation(4,:) = 0;
    fixation(:,4) = 0;
    
    %read in the trial info from the text file
    [trialnum respdisp fdbkdisp tarloc]=...
        textread('VCRT_trials.txt','%s %s %s %u');
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Prepare & give instructions. Both matlab text and image texts can be
    %used

    notEnd = 'You''ve finished this task, press the spacebar';   


%read in instruction images
instruct1=imread('instruct1.jpg'); instruct2=imread('instruct2.jpg');
instruct3=imread('instruct3.jpg'); instruct4=imread('instruct4.jpg');

Screen('PutImage', w, instruct1);
Screen('Flip', w);
WaitSecs(.5);
touch=0;
while touch==0
    [touch,tpress,keyCode]=PsychHID('KbCheck',usethiskeyboard);
    if keyCode(spaceBar); break; else touch=0; end
end; while KbCheck; end

Screen('PutImage', w, instruct2);
Screen('Flip', w);
WaitSecs(.5);
touch=0;
while touch==0
    [touch,tpress,keyCode]=PsychHID('KbCheck',usethiskeyboard);
    if keyCode(spaceBar); break; else touch=0; end
end; while KbCheck; end

Screen('PutImage', w, instruct3);
Screen('Flip', w);
WaitSecs(.5);
touch=0;
while touch==0
    [touch,tpress,keyCode]=PsychHID('KbCheck',usethiskeyboard);
    if keyCode(spaceBar); break; else touch=0; end
end; while KbCheck; end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Practice trails
    prac1resp=imread('prac1resp.jpg'); prac1fdbk=imread('prac1fdbk.jpg');
    prac2resp=imread('prac2resp.jpg'); prac2fdbk=imread('prac2fdbk.jpg'); 
    
    %first practice trial
    Screen('FillRect', w, white);
    Screen('PutImage', w, prac1resp);
    Screen('Flip', w);

    tstart=GetSecs;
    touch=0; noresponse=0;
    while touch==0
        [touch,tpress,keyCode]=PsychHID('KbCheck',usethiskeyboard);
        rt=(tpress-tstart)*1000;
        if  keyCode(key1)||keyCode(key2)||keyCode(key3)||keyCode(key4); break;
        else
            if touch; end;
            touch=0;
        end
    end
    
    Screen('PutImage', w, prac1fdbk);
    Screen('Flip', w); WaitSecs(fdbktime);
    FlushEvents('keyDown');
    Screen('FillRect', w, white);
    Screen('Flip', w); WaitSecs(.5);
    
   if ~noresponse  
            if keyCode(key1); resp = 1;
                ac=1;
            elseif keyCode(key2); resp = 2;
                ac=0;
            elseif keyCode(key3); resp = 3;
                ac=0; 
            elseif keyCode(key4); resp = 4;
                ac=0;
            end     
        else  
            resp='nil'; ac(m)=-1; rt(m)=-1;
        end
        
        fprintf(dataFile, ('\n%s\t%s\t%s\t%s\t%s\t%d\t%d\t%d\t%f'),...
            subjno,subjini,'0','prac1','prac1',1,resp,ac,rt);
    
    %second practice trial
     Screen('FillRect', w, white);
    Screen('PutImage', w, prac2resp);
    Screen('Flip', w);

    tstart=GetSecs;
    touch=0; noresponse=0;
    while touch==0
        [touch,tpress,keyCode]=PsychHID('KbCheck',usethiskeyboard);
        rt=(tpress-tstart)*1000;
        if  keyCode(key1)||keyCode(key2)||keyCode(key3)||keyCode(key4); break;
        else
            if touch; end;
            touch=0;
        end
    end
    
    Screen('PutImage', w, prac2fdbk);
    Screen('Flip', w); WaitSecs(fdbktime);
    FlushEvents('keyDown');
    Screen('FillRect', w, white);
    Screen('Flip', w); WaitSecs(.5);
    
   if ~noresponse  
            if keyCode(key1); resp = 1;
                ac=0;
            elseif keyCode(key2); resp = 2;
                ac=0; 
            elseif keyCode(key3); resp = 3;
                ac=1;
            elseif keyCode(key4); resp = 4;
                ac=0;
            end     
        else  
            resp='nil'; ac(m)=-1; rt(m)=-1;
   end
        
        fprintf(dataFile, ('\n%s\t%s\t%s\t%s\t%s\t%d\t%d\t%d\t%f'),...
            subjno,subjini,'0','prac2','prac2',3,resp,ac,rt);
    
    %screen to start experiment
    Screen('PutImage', w, instruct4);
    Screen('Flip', w);
    WaitSecs(.5);
    touch=0;
    while touch==0
        [touch,tpress,keyCode]=PsychHID('KbCheck',usethiskeyboard);
        if keyCode(spaceBar); break; else touch=0; end
    end; while KbCheck; end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Experimental trials
 
    for m = 1:numel(fdbkdisp)    
        % Response 
        respscreen = imread([respdisp{m}], 'jpg');
        Screen('PutImage', w, respscreen);
        Screen('Flip', w);
        
        tstart=GetSecs;
        touch=0; noresponse=0;
        while touch==0
            [touch,tpress,keyCode]=PsychHID('KbCheck',usethiskeyboard);
            rt(m)=(tpress-tstart)*1000;		
            if  keyCode(key1)||keyCode(key2)||keyCode(key3)||keyCode(key4); break;
            else if touch; end; touch=0; end
            touch=0;
        end
        
        if ~noresponse
            if keyCode(key1); resp = 1;
                if tarloc(m)==1; ac(m)=1;
                else ac(m)=0; end
            elseif keyCode(key2); resp = 2;
                if tarloc(m)==2; ac(m)=1;
                else ac(m)=0; end
            elseif keyCode(key3); resp = 3;
                if tarloc(m)==3; ac(m)=1;
                else ac(m)=0; end
            elseif keyCode(key4); resp = 4;
                if tarloc(m)==4; ac(m)=1;
                else ac(m)=0; end
            end
        else
            resp='nil'; ac(m)=-1; rt(m)=-1;
        end
        
        fprintf(dataFile, ('\n%s\t%s\t%s\t%s\t%s\t%d\t%d\t%d\t%f'),...
            subjno,subjini,trialnum{m},fdbkdisp{m},respdisp{m},tarloc(m),resp,ac(m),rt(m));
        
        FlushEvents('keyDown');
        touch=0;
        
        %Feedback screen
        fdbk = imread([fdbkdisp{m}], 'jpg');
        %Screen('FillRect', w, white); Screen('Flip', w); WaitSecs(.2);
        Screen('PutImage', w, fdbk);
        Screen('Flip', w);
        WaitSecs(fdbktime);
        
    end    
    
    ListenChar(0);
    
    %fclose('all');
    
   [nx, ny, bbox] = DrawFormattedText(w, notEnd, 'center', 'center'); %draws end note to get experimenter
    Screen('Flip', w);
    WaitSecs(.2);
    
    %press the spacebar to end
    FlushEvents('keyDown');
    touch=0;
    while touch==0
        [touch,tpress,keyCode]=PsychHID('KbCheck',usethiskeyboard);
        if keyCode(spaceBar); break; else touch=0; end
    end; while KbCheck; end
    
    totalExptTime = (GetSecs - startexpt)/60;
    ACmean = mean(ac);
    RTmean = mean(rt);
    
    %prints to command window
    %fprintf('\nExperiment time:\t%4f\t minutes',totalExptTime);
    %fprintf('\nAverage accuracy:\t%4f',ACmean);
    %fprintf('\nAverage response time:\t%4f\n',RTmean);

    ShowCursor; ListenChar;
    Priority(0);   
    
    tVCXT = totalExptTime;
    
catch
    ListenChar(0);
    ShowCursor;
    Screen('CloseAll');
    rethrow(lasterror);
end
end