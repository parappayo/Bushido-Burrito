package ui.flows 
{
	import wyverntail.core.FlowStates;
	
	public class FlowStates extends wyverntail.core.FlowStates
	{
		// common states
		public static const INVALID			:int = 0;
		public static const LOADING			:int = 1;
		public static const INIT			:int = 2;
		public static const IDLE			:int = 3;
		public static const ACTIVE			:int = 4;
		public static const EXIT			:int = 5;
		public static const INTRO			:int = 6;
		public static const OUTRO			:int = 7;
		public static const PAUSED			:int = 8;

		// child flows
		public static const FRONT_END_FLOW		:int = 1001;
		public static const IN_GAME_FLOW		:int = 1002;
		
		// screen states
		public static const LOADING_SCREEN		:int = 2001;
		public static const LEGAL_SCREEN		:int = 2002;
		public static const TITLE_SCREEN		:int = 2003;
		public static const PAUSE_SCREEN		:int = 2004;
		public static const MAIN_MENU_SCREEN	:int = 2005;
		public static const PAUSE_MENU_SCREEN	:int = 2006;
		public static const MESSAGE_DIALOG		:int = 2007;
		public static const INTRO_DIALOG		:int = 2008;
		public static const VICTORY_SCREEN		:int = 2009;
		public static const GAME_OVER_SCREEN	:int = 2010;
		public static const LEVEL_SELECT_SCREEN	:int = 2011;
		public static const CREDITS_SCREEN		:int = 2012;
		
		// Many Ninjas
		public static const NINJA_TOTALS_SCREEN		:int = 3000;
		public static const RAID_CASTLE_SCREEN		:int = 3001;
		public static const UPGRADES_SCREEN			:int = 3002;
	}
	
} // package

