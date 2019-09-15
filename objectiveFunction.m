function [ fitness ] = objectiveFunction(inputSeq, input_data)
	sz = size(input_data,1);
	slotsz = 4;
	orgSlotsz = slotsz;
	grptot = floor(sz/orgSlotsz);
	extra = sz-orgSlotsz*grptot;
	orgExtra = extra;
	CODEwt = 8; %weight for coding
	AnDwt = 4; %weight for Analysis & Design
	DBwt = 4; %weight for database
	REwt = 1; %weight for research and presentations

	%all skills?
	msp = 0; %missing skill penalty
	totalskills = 4;
	skillcount = [];
	backToNormal = false;
	fromSlot = slotsz;
	toSlot = slotsz;
	adj = 0;
	toadj = 0;

	for i = 1:grptot
		if(extra>0)
	%         slotsz = orgSlotsz+1;
			fromSlot = orgSlotsz+1;
			toSlot = orgSlotsz+1;
			extra = extra-1;
			backToNormal = false;
		else
			if(~backToNormal)
				toSlot = orgSlotsz;
				toadj = orgExtra;
				backToNormal = true;   
			end
		end
			 
		skills = zeros(totalskills, 1); %skill sum
		for s = 1:totalskills % coding, A&D, db, research
			for j = (i-1)*fromSlot+1+adj:i*toSlot + toadj + adj
				 skills(s) = skills(s)+input_data(inputSeq(j),s+1); %coding             
			end        
		end
		skillcount = [skillcount CODEwt*skills(1) + AnDwt*skills(2) + DBwt*skills(3) + REwt*skills(4)];
		for s = 1:totalskills
			if(skills(s)>0)
				skills(s) = 0; %for easy summation below
			else
				skills(s) = 1; %for easy summation below
			end
		end
		msp = msp + CODEwt*skills(1) + AnDwt*skills(2) + DBwt*skills(3) + REwt*skills(4);
		   
		if(backToNormal)
			fromSlot = orgSlotsz;
			toSlot = orgSlotsz;
			adj = orgExtra;
			toadj = 0;
		end
		
	end

	avSkillCount = sum(skillcount)/grptot;
	fitness = sum(abs(skillcount - avSkillCount)) + msp;

end
