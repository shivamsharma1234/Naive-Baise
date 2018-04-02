function [ Result_ham,Result_spam] = Naive( )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here W,Words ,ham,spam

global N_Spam N_Ham ham spam P_spam P_ham 

%******************************************************************************************************************************%
                                                                 %TRAINING
%******************************************************************************************************************************%

Training_Set_Folder = [uigetdir(''),'\']; % this comand helps to select the 'Train Data' folder for training  conating the spam and ham training data
TS_Vector = dir(Training_Set_Folder);  % this command stores the directory of training set folder
No_Folders_In_Training_Set_Folder = length(TS_Vector); % this command finds the number of forlders inside the Train Data (which is 2 in this case i.e Spam Train and Ham Train Folder ) 

Class_Count = 1;
W=[];


%This loop is the tarining loop
%This loop reads all the ham and spam folders and extract tokens from it 
for k=3:No_Folders_In_Training_Set_Folder  
    
    %Here we start the counting from 23 because the first two folders are
    %system files
    % in this loop we go inside the 'Train data Folder' and reads each Spam
    % Tain Folder and Ham Train Folder One by one
    Class_Folder = [Training_Set_Folder '\' TS_Vector(k).name,'\']; %this commad stores the path for the folders which are read one by one
    CF_Tensor = dir(Class_Folder);  % this command converts the string sequence as directory
    No_Files_In_Class_Folder(Class_Count) = length(CF_Tensor)-2; % thsi commad finds the number of files in each Spam and Ham Train folder
    
    Words=[];   
    for p = 3:No_Files_In_Class_Folder(Class_Count)+2
        
        Tmp_Path = Class_Folder;
        Tmp_Name = CF_Tensor(p).name;  % this is the file name matlab reading currently 
        Tmp_Path_Name = [Tmp_Path,Tmp_Name];
        fileID = fopen(Tmp_Path_Name,'r');  % this command opens each txt file in read mode and copies all the data of each txt file in fileID variable
        Intro = textscan(fileID,'%s'); % this commad converts segregates the each as individual token/word 
        %for example if my email is -  I am Going to for a walk today 
        % Then the output in textscan('I am Going to for a walk today ')={'I' ,'am', 'Going', 'to', 'for' ,'a' ,'walk','today' }
        
        
        Words=[Words,(unique(Intro{1}))']; % this command concatenates all the unique words/tokens read in each txt email
        fclose(fileID); % thsi commad closes the open txt file
        % it is required to close each file we read as there is some
        % limitation in matlab for how many files can be open at a time.
        
        
    end
    
    %Train_Data=[Train_Data;T_Data];
    
    W=[W,Words];  % here W stores all the words of ham and spam both
    
    % matlab reads the Ham Folder first before spam folder since
    % alphabetically H comes first
    if k==3  
        ham=freq(Words); % command finds the frequency of all the ham words/tokens stored so that it can form the Ham tarining Data set
        N_Ham=No_Files_In_Class_Folder(Class_Count); % N_Ham is the number of Ham emails in the 'Ham Train Data Folder'
    elseif k==4
        spam=freq(Words); % command finds the frequency of all the Spam words/tokens stored so that it can form the Spam tarining Data set
        N_Spam=No_Files_In_Class_Folder(Class_Count);% N_Spam is the number of spam emails in the 'Spam Train Data Folder'
    end
    
    
end

%Freq=freq(Words);


P_spam=N_Spam/(N_Spam+N_Ham);  % It is the probablity of Spam emails =Total Number of Spam Emails in Train Folder/(Total Emails Spma +Ham)
P_ham=N_Ham/(N_Spam+N_Ham);  % It is the probablity of Ham emails = Total Number of Ham Emails in Train Folder/(Total Emails Spma +Ham)

%******************************************************************************************************************************%
                                                                 %Testing 
%******************************************************************************************************************************%
%this loop is the testing loop which helps us to select the tarining and
%testing dataset

Test_Set_Folder = [uigetdir(''),'\'];% this comand helps to select the 'Test Data' folder for training  conating the spam and ham training data
TS_Vector = dir(Test_Set_Folder); % this command stores the directory of training set folder
No_Folders_In_Training_Set_Folder = length(TS_Vector);% this command finds the number of forlders inside the Train Data (which is 2 in this case i.e Spam Train and Ham Train Folder ) 

Class_Count = 1;
Temp=[];

for k=3:No_Folders_In_Training_Set_Folder
    
    Class_Folder = [Test_Set_Folder '\' TS_Vector(k).name,'\'];
    CF_Tensor = dir(Class_Folder);
    No_Files_In_Class_Folder(Class_Count) = length(CF_Tensor)-2;
    
    Temp=[];
    File_temp=[];
    for p = 3:No_Files_In_Class_Folder(Class_Count)+2
        Tmp_Path = Class_Folder;
        Tmp_Name = CF_Tensor(p).name;
        Tmp_Path_Name = [Tmp_Path,Tmp_Name];
        fileID = fopen(Tmp_Path_Name,'r');
        Intro = textscan(fileID,'%s');
        fclose(fileID);
        
        a(p-2,:)={Tmp_Name}; % this command here  is stroing the file name of each txt file as string in a single column
        Temp(p-2,:)=check(unique(((Intro{1})'))); %here the function returns 1(means email is HAM ) or 0(means email is SPAM)
        %Inside the Check() we put all the unique words we stored in the
        %FileID variable which is a cell
        %fileID{1} means that since it is cell return me the value stored
        %in your first cell 
        %fileID=[{'I' ,'am', 'Going', 'to', 'for' ,'a' ,'walk','today' }]
        %fileID{1} gives us {'I' ,'am', 'Going', 'to', 'for' ,'a' ,'walk','today' }
    end
    
    if k==3
        T_Result_ham=Temp; % it stores the result of the all the Ham Test Folder 
        Folder_ham=a;  % this variable now stores all the HAm Folder name
    else
        T_Result_spam=Temp; % it stores the result of the all the Spam Test Folder
        Folder_spam=a; % this variable now stores all the Spam Folder name
    end
end
    
for i=1:size(T_Result_ham,1)
    Result_ham(i,:)=[Folder_ham(i),T_Result_ham(i)];  % this command is combining the output as
    Result_spam(i,:)=[Folder_spam(i),T_Result_spam(i)];
   
    
end

% if you print  Result_ham and  Result_spam
    %'ham_1.txt'    [1] // here 1 represents that the
    %'ham_2.txt'    [1] txt file is Spam
    %'ham_3.txt'    [1]
    %'ham_4.txt'    [1]
    %'ham_5.txt'    [1]
    
    %and 
    
    %'spam_1.txt'    [0]                  // here 0 represents that the
    %'spam_2.txt'    [0]                      txt file is Spam
    %'spam_3.txt'    [0]
    %'spam_4.txt'    [1]
    %'spam_5.txt'    [1]
    
    % as you can see above output that each one is represented in '' so
    % each one is a cell here so while comparing 
sprintf('Number of Ham mails in Ham folder : %d',sum(cell2mat(Result_ham(:,2))==1))  % basically here it counts the number of folders in Ham whose result is 1
sprintf('Number of Spam mails in Spam folder : %d',No_Files_In_Class_Folder(Class_Count)-sum(cell2mat(Result_spam(:,2))==1)) % here it counts the number of files whose output is 1 then it subtracts from the total number 
%of Spam folders which gives us the number of spam emails 





end


%this function computes whether the email is a spam or a ham using the
%trained dataset that we get 
function [o]=check(words)
global N_Spam N_Ham ham spam P_spam P_ham 

s=0;
hm=[];
sm=[];

for i=1:numel(words)
    
    %'word1'    [5] // here 1 represents that the
    %'word2'    [3] txt file is Spam
    
    
    hm=ham(strncmp(ham(:,1),words(i), numel(cell2mat(words(i)))),:); % Here we fetch the row where the word is equal is the token in the Ham folder, so that we find the corresponding frequency of each word in Ham file in the second column
    % so it retuens  row 'word1'    [5]
    sm=spam(strncmp(spam(:,1),words(i), numel(cell2mat(words(i)))),:); % here also we find the frequency of the same word in the spam folder 
   
    % so it can also happen that hm or sm is empty if the word is not
    % present in the Ham or Spam Trained Data set so in that case it s empty 
    
    if ~isempty(sm)&& ~isempty(hm)  % case if the word is present in Spam and Ham also
        
    
      s=s+log((cell2mat(sm(1,2))*N_Ham)/(cell2mat(hm(1,2))*N_Spam));
  
    elseif  isempty(sm)&& ~isempty(hm) % case if the word is present in  Ham only but not in spam
        
        s=s+log((0.01*N_Ham)/(cell2mat(hm(1,2))));
    elseif ~isempty(sm)&& isempty(hm) % case if the word is present in  Spam only but not in Ham
        s=s+log((cell2mat(sm(1,2)))/(N_Spam));
    
    end
    
end

s=s+log(P_spam/P_ham);


%	If the Ratio is grater than 0 then we classify it as spam
%	IF the ratio is less than 0 then we classify it as ham

if s>=0 %	If the Ratio is grater than 0 then we classify it as spam
    o=0;
    
elseif s<0 %	IF the ratio is less than 0 then we classify it as ham
    o=1;
   
    
end


end


function [p]=freq(words)
[unique_words, i, j] = unique(words);
frequency_count = hist(j, 1:max(j));
[~, sorted_locations] = sort(frequency_count);
sorted_locations = fliplr(sorted_locations);
words_sorted_by_frequency = unique_words(sorted_locations).';
frequency_of_those_words = frequency_count(sorted_locations).';
p=[(words_sorted_by_frequency), num2cell(frequency_of_those_words)];
end

