function DelaySound(soundID_,time_)
{
	with (obj_Menu)
	{
		soundID = soundID_
		soundDelay = time_
	}
}

function Ejected(name){
	var snd = noone
	
	switch (name)
	{
		case NAME.Adam:
			snd = choose(AdamDeath,AdamDeath2,AdamDeath3,AdamEject,AdamEject2)
			break
			
		case NAME.OkMan:
			snd = choose(BorekEject,BorekDeath2)
			break
			
		case NAME.Jahim:
			snd = choose(JachymDEATH,JachymDeath2,JachymEject)
			break
			
		case NAME.Katt:
			snd = choose(KatkaEject,KatkaDeath2)
			break
			
		case NAME.Kuba:
			snd = choose(KubaEject)
			break
			
		case NAME.Ondra:
			snd = choose(Ondrej)
			break
			
		case NAME.Tom:
			snd = choose(TomasDeath,TomasDeath)
			break
			
		case NAME.Vojta:
			snd = choose(VojtaDeath,VojtaDeath3,VojtaDeath4,VojtaEject,VojtaEject2)
			break
	}
	audio_play_sound(sndEjected,0,0)
	DelaySound(snd,60)
}

function Died(killer){
	var snd = noone
	
	switch (killer)
	{
		case NAME.Adam:
			snd = choose(AdamKill)
			break
			
		case NAME.OkMan:
			snd = choose(BorekKill,BorekKill2)
			break
			
		case NAME.Jahim:
			snd = choose(JachymKill,JachymKill2)
			break
			
		case NAME.Katt:
			snd = choose(KatkaKill,KatkaKill2,KatkaKill3,KatkaKill4)
			break
			
		case NAME.Kuba:
			snd = choose(KubaEject)
			break
			
		case NAME.Ondra:
			snd = choose(OndrejMeeting)
			break
			
		case NAME.Tom:
			snd = choose(TomasKill,TomasKill2,TomasKill3)
			break
			
		case NAME.Vojta:
			snd = choose(VojtaKill,VojtaKill2,VojtaKill3)
			break
	}
	audio_play_sound(sndKill,0,0)
	DelaySound(snd,80)
}

function Killed(corpse){
	var snd = noone
	
	switch (corpse)
	{
		case NAME.Adam:
			snd = choose(AdamDeath,AdamDeath2,AdamDeath3)
			break
			
		case NAME.OkMan:
			snd = choose(BorekDeath,BorekDeath2)
			break
			
		case NAME.Jahim:
			snd = choose(JachymDeath2)
			break
			
		case NAME.Katt:
			snd = choose(KatkaDeath2)
			break
			
		case NAME.Kuba:
			snd = choose(KubaEject)
			break
			
		case NAME.Ondra:
			snd = choose(OndrejMeeting)
			break
			
		case NAME.Tom:
			snd = choose(TomasDeath,TomasDeath2)
			break
			
		case NAME.Vojta:
			snd = choose(VojtaDeath,VojtaDeath2,VojtaDeath3,VojtaDeath4)
			break
	}
	audio_play_sound(sndKill,0,0)
	DelaySound(snd,80)
}

function EmergencyMeeting(caller){
	var snd = noone
	
	switch (caller)
	{
		case NAME.Adam:
			snd = choose(AdamEmergency)
			break
			
		case NAME.OkMan:
			snd = choose(BorekEmergency,BorekEmergency2)
			break
			
		case NAME.Jahim:
			snd = choose(JachymEmergency2,JachymEmergency3)
			break
			
		case NAME.Katt:
			snd = choose(KatkaEmergency,KatkaEmergency2)
			break
			
		case NAME.Kuba:
			snd = choose(KubaEject)
			break
			
		case NAME.Ondra:
			snd = choose(OndrejMeeting)
			break
			
		case NAME.Tom:
			snd = choose(TomasEmergency,TomasEmergency2,TomasEmergency3)
			break
			
		case NAME.Vojta:
			snd = choose(VojtaEmergency,VojtaEmergency2)
			break
	}
	audio_play_sound(sndEmergencyMeeting,0,0)
	DelaySound(snd,180)
}