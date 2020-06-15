#if defined _gloves_included_
  #endinput
#endif
#define _gloves_included_

#if defined _gloves_afplus_included_
  #endinput
#endif
#define _gloves_afplus_included_

// returns if the client is using any gloves or not
native bool Gloves_IsClientUsingGloves(int client);

// registers arms model, so that it can be set when the player decides to NOT use any gloves (i.e. use default) using !gloves menu
native void Gloves_RegisterCustomArms(int client, const char[] armsModel);

// any plugin that changes player model OR player arm model, should call this native instead of setting it itself with SetEntPropString(client, Prop_Send, "m_szArmsModel", armsModel);
// even if the plugin is not setting an arms model, but only a player model, you have to call this function and set a default arms model or arms will be invisible when using default gloves
native void Gloves_SetArmsModel(int client, const char[] armsModel);

// returns the registered custom arms model. "" if not set
native void Gloves_GetArmsModel(int client, char[] armsModel, int size);

// ArmsFix+: Additional Natives to disable gloves and etc

// disables gloves
native void Gloves_DisableClientGloves(int client, bool disable = true);

// if gloves disabled
native bool Gloves_IsClientGlovesDisabled(int client);

// requires an update (automatically after Gloves_DisableClientGloves)
native void Gloves_RequestGlovesUpdate(int client);
