package  
{
	import feathers.themes.MinimalMobileTheme;
	import flash.display.BitmapData;
	import starling.display.Sprite;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.EnterFrameEvent;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	import sim.*;
	import ui.flows.RootFlow;
	import ui.flows.FlowStates;
	
	public class Game extends Sprite
	{
		// these game state managers are managed by UI screens
		public var Recruit :RecruitStage;
		public var TrashMobs :TrashMobsStage;
		public var Boss :BossStage;
		public var DifficultyTier :int;
		
		// character system
		public var CharaNames :CharacterNames;
		public var CharaPool :CharacterPool;

		// should always be on top of other gameplay
		public var UISprite :Sprite;

		private var _inputHandler :InputHandler;
		private var _rootFlow :RootFlow;
		
		public function Game() 
		{
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			
			Assets.init();
			
			CharacterClasses.initAttributeOrder();
			
			Recruit = new RecruitStage();
			TrashMobs = new TrashMobsStage();
			Boss = new BossStage();
			DifficultyTier = 0;
			
			CharaNames = new CharacterNames();
			CharaPool = new CharacterPool();
			CharaPool.populate(Settings.CharaPoolCount, CharaNames);
		}
				
		protected function handleAddedToStage(event :Event) :void
		{
			removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			
			new MinimalMobileTheme();
			
			const atlasBitmapData :BitmapData = (new MinimalMobileTheme.ATLAS_IMAGE()).bitmapData;
			const atlas :TextureAtlas = new TextureAtlas(Texture.fromBitmapData(atlasBitmapData, false), XML(new MinimalMobileTheme.ATLAS_XML()));
			
			TextField.registerBitmapFont(new BitmapFont(
				atlas.getTexture("pf_ronda_seven_0"),
				XML(new MinimalMobileTheme.ATLAS_FONT_XML())),
				"theme_font");
			
			UISprite = new Sprite();
			
			_inputHandler = new InputHandler(this);
			addChild(_inputHandler);
			
			_rootFlow = new RootFlow(this);
			_rootFlow.changeState(FlowStates.FRONT_END_FLOW);
			
			addChild(UISprite);
			addEventListener(EnterFrameEvent.ENTER_FRAME, handleEnterFrame);
		}
		
		public function handleSignal(signal :int, args :Object = null) :void
		{
			_rootFlow.handleSignal(signal);
		}
		
		public function handleEnterFrame(event :EnterFrameEvent) :void
		{
			_rootFlow.update(event.passedTime);
		}

		public function pause() :void
		{
			_rootFlow.handleSignal(Signals.PAUSE_GAME);
		}
		
		public function resume() :void
		{
			_rootFlow.handleSignal(Signals.RESUME_GAME);			
		}
	}

} // package
