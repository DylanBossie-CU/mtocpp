classdef MatlabDocMaker
    % MatlabDocMaker: Class for information & tasks concerning the KerMor
    % documentation.
    %
    % Prerequisites:
    % - \c doxygen: mtoc++ is merely a filter for doxygen
    % - \c mtocpp, \c mtocpp_post on the search/environment paths
    % - \c m4: A macro parser [Unix only]
    %
    % @author Daniel Wirtz @date 2011-10-13
    %
    % @change{1,1,dw,2011-11-04} Changed the name to MatlabDocMaker in
    % order to export it into the mtoc++ distribution later.
    %
    % @new{1,1,dw,2011-10-13} Added this class and moved documentation related
    % stuff here from the KerMor class.
    %
    % This class is part of the mtoc++ tool
    % - \c Homepage http://www.morepas.org/software/mtocpp
    % - \c License http://www.morepas.org/software/mtocpp/licensing.html
    
    methods(Static)
        function name = getProjectName
            % Returns the project name.
            %
            % @note Changing the return value of this method will require
            % another execution of MatlabDocMaker.setup as the preferences
            % key also depends on it.
            %
            % Return values:
            % name: The project name
            name = 'My mtoc++ powered project';
        end
        
        function version = getProjectVersion
            % Returns the current version of the project.
            %
            % @note The built-in @@new and @@change tags from the
            % Doxyfile.m4 support two-level versioning a la X.X.
            %
            % Return values:
            % version: The project version
            version = '0.1';
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% End of user defined methods.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties(Constant)
        PrefTag = 'MTOCPP';
    end
    
    methods(Static, Sealed)
        % The KerMor documentation directory, i.e. where createDocs places
        % the generated documentation.
        %
        % Can be set during Documentation.setup
        %
        
        function dir = getOutputDirectory
            % Returns the directory where the applications source files
            % reside
            %
            % Return values:
            % dir: The output directory @type char
            dir = getpref(MatlabDocMaker.getProjPrefTag,'outdir',[]);
            if isempty(dir)
                error('MatlabDocMaker preferences not set. Re-run setup method.');
            end
        end
        
        function dir = getSourceDirectory
            % Returns the directory where the applications source files
            % reside
            %
            % Return values:
            % dir: The project source directory @type char
            dir = getpref(MatlabDocMaker.getProjPrefTag,'srcdir',[]);
            if isempty(dir)
                error('MatlabDocMaker preferences not set. Re-run setup method.');
            end
        end
        
        function dir = getConfigDirectory
            % Returns the directory where the applications documentation
            % configuration files reside
            %
            % This folder must contain at least the files "mtoc.conf" and
            % "Doxyfile.m4"
            %
            % Return values:
            % dir: The documentation configuration directory @type char
            dir = getpref(MatlabDocMaker.getProjPrefTag,'confdir',[]);
            if isempty(dir)
                error('MatlabDocMaker preferences not set. Re-run setup method.');
            end
        end
        
        function bin = getDoxygenBin
            % Allows access to a custom doxygen binary.
            %
            % Return values:
            % bin: The fully qualified path to a custom doxygen executable @type char
            
            bin = getpref(MatlabDocMaker.getProjPrefTag,'doxybin',[]);
            % If no preference is set, expect the doxygen binary to be
            % included in the local path.
            if isempty(bin)
                bin = 'doxygen';
            end
        end
    end
        
    methods(Static)
        
        function open
            % Opens the generated documentation.
            web(fullfile(MatlabDocMaker.getOutputDirectory, 'index.html'));
        end
        
        function create(open)
            % Creates the Doxygen documentation
            %
            % Parameters:
            % open: Set to true if the documentation should be opened after
            % successful compilation @type bool @default false
           
            if nargin == 0
                open = false;
            end
            
            % Save current working dir and change into the KerMor home
            % directory; only from there all classes and packages are
            % detected properly.
            curdir = pwd;
            cd(MatlabDocMaker.getSourceDirectory);
            %% Operation-system dependent actions
            if isunix
                MatlabDocMaker.createUnix;
            elseif ispc
                MatlabDocMaker.createWindows;
            end
            cd(curdir);
            
            %% Open index.html if wanted
            if open
                MatlabDocMaker.open;
            end
        end
        
        function setup
            % Runs the setup script for MatlabDocMaker and collects all
            % necessary paths in order for the documentation creation to
            % work properly.
            
            if isempty(MatlabDocMaker.getProjectName) || isempty(MatlabDocMaker.getProjectVersion)
                error('Please set/write the code for the getProjectName and getProjectVersion methods first!');
            end
            
            fprintf('<<<< Welcome to the MatlabDocMaker setup for your project %s! >>>>\n',MatlabDocMaker.getProjectName);
            %% Source directory
            srcdir = getpref(MatlabDocMaker.getProjPrefTag,'srcdir',[]);
            word = 'keep';
            if isempty(srcdir)
                srcdir = pwd;
                word = 'set';
            end
            str = sprintf('Do you want to %s %s as your projects source directory?\n(Y)es/(N)o?: ',word,srcdir);
            ds = lower(input(str,'s'));
            if isequal(ds,'n')
                d = uigetdir(srcdir,'Please select the projects source directory');
                if d == 0
                    error('No source directory specified. Aborting setup.');
                end
                srcdir = d;
            end
            setpref(MatlabDocMaker.getProjPrefTag,'srcdir',srcdir);
            
            %% Config directory
            confdir = getpref(MatlabDocMaker.getProjPrefTag,'confdir',[]);
            word = 'keep';
            if isempty(confdir)
                confdir = fullfile(srcdir,'documentation');
                word = 'set';
            end
            str = sprintf('Do you want to %s %s as your documentation configuration files directory?\n(Y)es/(N)o?: ',word,confdir);
            ds = lower(input(str,'s'));
            if isequal(ds,'n')
                d = uigetdir(confdir,'Please select the documentation configuration directory');
                if d == 0
                    error('No documentation configuration directory specified. Aborting setup.');
                end
                confdir = d;
            end
            setpref(MatlabDocMaker.getProjPrefTag,'confdir',confdir);
            
            %% Output directory
            outdir = getpref(MatlabDocMaker.getProjPrefTag,'outdir',[]);
            word = 'keep';
            if isempty(outdir)
                outdir = confdir;
                word = 'set';
            end
            str = sprintf('Do you want to %s %s as your documentation output directory?\n(Y)es/(N)o?: ',word,outdir);
            ds = lower(input(str,'s'));
            if isequal(ds,'n')
                d = uigetdir(outdir,'Please select the documentation output directory');
                if d == 0
                    error('No documentation output directory specified. Aborting setup.');
                end
                outdir = d;
            end
            setpref(MatlabDocMaker.getProjPrefTag,'outdir',outdir);
            
            %% Doxygen binary
            doxybin = getpref(MatlabDocMaker.getProjPrefTag,'doxybin',[]);
            word = sprintf('Do you want to choose a different doxygen binary than %s?\n(Y)es/(N)o?: ',doxybin);
            if isempty(doxybin)
                [st, doxybin] = system('which doxybin');
                if st == 0
                    word = sprintf('Doxygen found at %s. Do you want to specify a custom doxygen binary?\n(Y)es/(N)o?: ',doxybin);
                else
                    word = sprintf('No doxygen executable found. Please type "y" to manually select a doxygen binary. ');
                end
            end
            ds = lower(input(word,'s'));
            if isequal(ds,'y')
                d = uigetfile(pwd,'Please select a doxygen binary');
                if d == 0
                    error('No doxygen binary specified. Aborting setup.');
                end
                doxybin = d;
            end
            setpref(MatlabDocMaker.getProjPrefTag,'doxybin',doxybin);
            
            fprintf('<<<< MatlabDocMaker setup successful. >>>>\nYou can now create your projects documentation by running MatlabDocMaker.create\n');
        end
    end
    
    methods(Static, Access=private)
        
        function value = getProjPrefTag
            str = MatlabDocMaker.getProjectName;
            value = [MatlabDocMaker.getProjPrefTag '_' str(regexp(str,'[a-zA-z]'))];
        end
        
        function createUnix
            % Creates the KerMor documentation on UNIX platforms.
            
            cdir = MatlabDocMaker.getConfigDirectory;
            % Create "configured" binary
            cbin = fullfile(cdir,'mtocpp_filter.sh');
            f = fopen(cbin,'w');
            fprintf(f,'#!/bin/bash\nmtocpp $1 %s',fullfile(cdir,'mtoc.conf'));
            fclose(f);
            unix(['chmod +x ' cbin]);
            
            % Process macros in the Doxyfile.m4 file using m4
            system(sprintf('m4 -D @OutputDir=%s -D @SourceDir=%s -D @ConfDir=%s -D @ProjectName="%s" @ProjectVersion=%s %s/Doxyfile.m4 > %s/Doxyfile',...
                 MatlabDocMaker.getOutputDirectory, MatlabDocMaker.getSourceDirectory, cdir,...
                 MatlabDocMaker.getProjectName, MatlabDocMaker.getProjectVersion, cdir, cdir));
            
            tex = fullfile(cdir,'latexextras.m4');
            if exist(tex,'file') == 2
                % # Parse the kermorlatex include style file
                system(sprintf('m4 -D @ConfDir=%s %s > %s/latexextras.sty',...
                    cdir,tex,cdir));
            else
                % Create empty file
                system(sprintf('touch %s/latexextras.sty',cdir));
            end
            
            %% Call doxygen
            [s,r] = system(sprintf('%s %s/Doxyfile 2>&1 1>%s/doxygen.log | grep -v synupdate | grep -v docupdate | grep -v display | grep -v subsref | tee %s/doxygen.err',...
                 MatlabDocMaker.getDoxygenBin,cdir,MatlabDocMaker.getOutputDirectory, MatlabDocMaker.getOutputDirectory));
             
            %% Postprocess
            [s,pr] = system(sprintf('mtocpp_post %s',MatlabDocMaker.getOutputDirectory));
            
            %% Tidy up
            delete(cbin);
            delete(fullfile(cdir,'latexextras.sty'));
            delete(fullfile(cdir,'Doxyfile'));
            
            %% Process warnings
            wpos = strfind(r,'Logged warnings:');
            if ~isempty(wpos)
                endpos = strfind(r,'Complete log file');
                cprintf([0 .5 0],r(1:wpos-1));
                cprintf([1,.4,0],strrep(r(wpos:endpos-1),'\','\\'));
                cprintf([0 .5 0],r(endpos:end));
            else
                cprintf([0 .5 0],strrep(r,'\','\\'));
            end
            fprintf('\n');
        end
        
        function createWindows
            % Creates the documentation on a windows platform.
            %
            % Currently not implemented.
            error('Creating documentation on Windows is not yet implemented.');
        end
    end
    
end