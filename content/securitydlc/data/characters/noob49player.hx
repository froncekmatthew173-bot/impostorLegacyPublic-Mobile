function onCreatePost()
{
	if (hasPet) pet.loadPet('greypet');
	if (!hasPet) iconP1.changeIcon('noob49alone');
	
	if (curSong == 'Identity Crisis')
	{
		copyPet.loadPet('greypet');
	}
	if (curSong == 'Delusion' || curSong == 'Blackout' || curSong == 'Neurotic')
	{
		triggerEventNote('Change Character', '0', 'noob49dark');
		if (FlxG.random.bool()) // 50%/50% easter egg
		{
			pet.alpha = 0.001;
			triggerEventNote('Change Character', 'dad', 'minigreyopscary');
			game.dad.x = 900;
			game.dad.y = 680;
			iconP1.changeIcon('noob49alone');
		}
		else
		{
			pet.alpha = 0.001;
			iconP1.changeIcon('noob49alone');
		}
	}
	if (curSong == 'Finale' || curSong == 'Defeat')
	{
		triggerEventNote('Change Character', '0', 'noob49dark');
	}
	if (curSong == 'Turbulence')
	{
		pet.alpha = 0.001;
		iconP1.changeIcon('noob49alone');
	}
	if (curSong == 'Triple Threat')
	{
		pet.alpha = 0.001;
		iconP1.changeIcon('noob49alone');
	}
	if (curSong == 'Pinkwave' || curSong == 'Heartbeat')
	{
		greymira.alpha = 0.001;
	}
	if (curSong == 'Sauces Moogus')
	{
		gray.alpha = 0.001;
	}
	if (gf != null)
	{
		if (gf.curCharacter == "triplespeaker")
		{
			pet.alpha = 0.001;
			iconP1.changeIcon('noob49alone');
		}
	}
}
function onEvent(eventName, value1, value2)
{
	switch (eventName)
		{
		case 'Legacy':
			if (curSong == 'Identity Crisis'){
			switch (value1)
				{
					case 'black':
						triggerEventNote('Change Character', '0', 'noob49dark');
				}
			}
			if (curSong == 'Double Kill'){
				switch (value1)
				{
					case 'readykill':
						triggerEventNote('Change Character', '0', 'noob49dark');
				}
			}
		}
}