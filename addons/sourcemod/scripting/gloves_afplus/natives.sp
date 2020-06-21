/*  CS:GO Gloves SourceMod Plugin
 *
 *  Copyright (C) 2017 Kağan 'kgns' Üstüngel
 * 
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) 
 * any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT 
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS 
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with 
 * this program. If not, see http://www.gnu.org/licenses/.
 */

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	CreateNative("Gloves_IsClientUsingGloves", Native_IsClientUsingGloves);
	CreateNative("Gloves_RegisterCustomArms", Native_RegisterCustomArms);
	CreateNative("Gloves_SetArmsModel", Native_SetArmsModel);
	CreateNative("Gloves_GetArmsModel", Native_GetArmsModel);
	CreateNative("Gloves_DisableClientGloves", Native_DisableClientGloves);
	CreateNative("Gloves_IsClientGlovesDisabled", Native_IsClientGlovesDisabled);
	CreateNative("Gloves_RequestGlovesUpdate", Native_RequestGlovesUpdate);
	return APLRes_Success;
}

public int Native_IsClientUsingGloves(Handle plugin, int numParams)
{
	int clientIndex = GetNativeCell(1);
	int playerTeam = GetClientTeam(clientIndex);
	return g_iGloves[clientIndex][playerTeam] != 0;
}

public int Native_RegisterCustomArms(Handle plugin, int numParams)
{
	int clientIndex = GetNativeCell(1);
	int playerTeam = GetClientTeam(clientIndex);
	GetNativeString(2, g_CustomArms[clientIndex][playerTeam], 256);
}

public int Native_SetArmsModel(Handle plugin, int numParams)
{
	int clientIndex = GetNativeCell(1);
	int playerTeam = GetClientTeam(clientIndex);
	GetNativeString(2, g_CustomArms[clientIndex][playerTeam], 256);
	if(g_iGloves[clientIndex][playerTeam] == 0)
		AF_SetClientArmsModel(clientIndex, g_CustomArms[clientIndex][playerTeam]);
}

public int Native_GetArmsModel(Handle plugin, int numParams)
{
	int clientIndex = GetNativeCell(1);
	int playerTeam = GetClientTeam(clientIndex);
	int size = GetNativeCell(3);
	AF_GetClientArmsModel(clientIndex, g_CustomArms[clientIndex][playerTeam], size);
	SetNativeString(2, g_CustomArms[clientIndex][playerTeam], size);
}

public int Native_DisableClientGloves(Handle plugin, int numParams)
{
	int clientIndex = GetNativeCell(1);
	bool is_disable = GetNativeCell(2);
	g_bIsClientGlovesBlocked[clientIndex] = is_disable;
	if(is_disable)
	{
		AF_DisableClientArmsUpdate(clientIndex, false);
		AF_RequestArmsUpdate(clientIndex);
		int ent = GetEntPropEnt(clientIndex, Prop_Send, "m_hActiveWeapon");
		if(ent != -1) SetEntPropEnt(clientIndex, Prop_Send, "m_hActiveWeapon", -1);
		DataPack dpack;
		CreateDataTimer(0.1, ResetGlovesTimer, dpack);
		dpack.WriteCell(clientIndex);
		dpack.WriteCell(ent);
		ent = GetEntPropEnt(clientIndex, Prop_Send, "m_hMyWearables");
		if(ent != -1) AcceptEntityInput(ent, "KillHierarchy");
	}
	else
	{
		AF_DisableClientArmsUpdate(clientIndex, g_iGloves[clientIndex][GetClientTeam(clientIndex)]!=0);
		GivePlayerGloves(clientIndex);
	}
}

public int Native_IsClientGlovesDisabled(Handle plugin, int numParams)
{
	return g_bIsClientGlovesBlocked[GetNativeCell(1)];
}

public int Native_RequestGlovesUpdate(Handle plugin, int numParams)
{
	int clientIndex = GetNativeCell(1);
	if(g_bIsClientGlovesBlocked[clientIndex])
	{
		AF_DisableClientArmsUpdate(clientIndex, false);
		AF_RequestArmsUpdate(clientIndex);
		int ent = GetEntPropEnt(clientIndex, Prop_Send, "m_hActiveWeapon");
		if(ent != -1) SetEntPropEnt(clientIndex, Prop_Send, "m_hActiveWeapon", -1);
		DataPack dpack;
		CreateDataTimer(0.1, ResetGlovesTimer, dpack);
		dpack.WriteCell(clientIndex);
		dpack.WriteCell(ent);
		ent = GetEntPropEnt(clientIndex, Prop_Send, "m_hMyWearables");
		if(ent != -1) AcceptEntityInput(ent, "KillHierarchy");
	}
	else
	{
		AF_DisableClientArmsUpdate(clientIndex);
		GivePlayerGloves(clientIndex);
	}
}