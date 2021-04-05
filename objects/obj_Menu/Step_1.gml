buttonIsSelected = false;

if (0.01 > random(100) and room = rm_Menu  and !audio_is_playing(Waiting)) audio_play_sound(Waiting,0,0)

if (soundDelay = 0)
{
	audio_sound_gain(soundID,8,0)
	audio_play_sound(soundID,0,0)
}
soundDelay--

if (menuStatePrev = noone && menuState != noone) audio_sound_gain(sndAmbience,0,3000)
if (menuStatePrev != noone && menuState = noone) audio_sound_gain(sndAmbience,0.15,7000)