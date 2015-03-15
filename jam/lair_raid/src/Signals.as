package  
{
	public class Signals 
	{
		// global
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
		public static const PAUSE_GAME				:int = 1008;
		public static const RESUME_GAME				:int = 1009;
		
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
		
		// generic gameplay
		public static const VICTORY					:int = 3001;
		public static const PLAYER_DIED				:int = 3002;
		public static const SPAWN_ENEMY				:int = 3003;
		public static const SPAWN_EFFECT			:int = 3004;
		public static const CHECK_COLLISION			:int = 3005;
		
	} // class

} // package
