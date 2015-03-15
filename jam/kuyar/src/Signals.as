package  
{
	public class Signals 
	{
		public static const NONE					:int = 0;
		
		// system
		public static const FATAL_ERROR				:int = 1000;
		public static const CONTROLLER_DISCONNECT	:int = 1001;
		public static const NETWORK_DISCONNECT		:int = 1002;
		public static const DEVICE_LOST				:int = 1003;
		public static const SYSTEM_MENU_OPEN		:int = 1004;
		public static const DISK_EJECT				:int = 1005;
		public static const LOAD_FAILED				:int = 1006;
		public static const SAVE_FAILED				:int = 1007;
		public static const LOAD_START				:int = 1008;
		public static const SAVE_START				:int = 1009;
		public static const LOAD_COMPLETE			:int = 1010;
		public static const SAVE_COMPLETE			:int = 1011;
		public static const APP_EXIT				:int = 1012;
		
		// input
		public static const MOVE_UP_KEYUP			:int = 2000;
		public static const MOVE_UP_KEYDOWN			:int = 2001;
		public static const MOVE_DOWN_KEYUP			:int = 2002;
		public static const MOVE_DOWN_KEYDOWN		:int = 2003;
		public static const MOVE_LEFT_KEYUP			:int = 2004;
		public static const MOVE_LEFT_KEYDOWN		:int = 2005;
		public static const MOVE_RIGHT_KEYUP		:int = 2006;
		public static const MOVE_RIGHT_KEYDOWN		:int = 2007;
		public static const ACCEPT_KEYUP			:int = 2008;
		public static const ACCEPT_KEYDOWN			:int = 2009;
		public static const BACK_KEYUP				:int = 2010;
		public static const BACK_KEYDOWN			:int = 2011;
		public static const ACTION_KEYUP			:int = 2012;
		public static const ACTION_KEYDOWN			:int = 2013;
		
		// game
		public static const PROJECTILE_ADD			:int = 3000;
		public static const PROJECTILE_REMOVE		:int = 3001;
		public static const EXPLOSION_EVENT			:int = 3002;
		public static const LEVEL_TRANSITION		:int = 3003;
		public static const PLAYER_DIED				:int = 3004;
		public static const PAUSE_GAME				:int = 3005;
		public static const RESUME_GAME				:int = 3006;
		public static const LEVEL_RESET				:int = 3007;
		public static const VICTORY					:int = 3008;
		public static const TELEPORT_PLAYER			:int = 3009;
		public static const CENTER_CAMERA			:int = 3010;
		public static const SHOW_DIALOG				:int = 3011;
	}

} // package
