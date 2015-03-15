package sim 
{
	import wyverntail.core.*;

	/**
	 *  Manages the castles that the player can invade
	 */
	public class CastlePool extends Component
	{
		// http://en.wikipedia.org/wiki/Japan%27s_Top_100_Castles
		
		public const CastleNames :Array = [
			// Touhoku
			"Hirosaki-jou",
			"Ne-jou",
			"Morioka-jou",
			"Sendai-jou",
			"Taga-jou",
			"Kubota-jou",
			"Yamagata-jou",
			"Nihonmatsu-jou",
			"Aizuwakamatsu-jou",
			"Komine-jou",

			// Hokkaidou
			"Nemuro Peninsula Chashiato",
			"Goryoukaku",
			"Matsumae-jou",
			
			// Kantou
			"Mito-jou",
			"Banna-ji",
			"Minowa-jou",
			"Kanayama-jou",
			"Hachigata-jou",
			"Kawagoe-jou",
			"Sakura-jou",
			"Edo-jou",
			"Hachiouji-jou",
			"Odawara-jou",
			"Tsutsujigasaki-jou",
			"Koufu-jou",
			"Matsushiro-jou",
			"Ueda-jou",
			"Komoro-jou",
			"Matsumoto-jou",
			"Takatou-jou",
			"Shibata-jou",
			"Kasugayama-jou",
			
			// Chuubu
			"Takaoka-jou",
			"Nanao-jou",
			"Kanazawa-jou",
			"Maruoka-jou",
			"Ichijoudani-jou",
			"Iwamura-jou",
			"Gifu-jou",
			"Yamanaka-jou",
			"Sunpu-jou",
			"Kakegawa-jou",
			"Inuyama-jou",
			"Nagoya-jou",
			"Okazaki-jou",
			"Nagashino-jou",
			"Iga Ueno-jou",
			"Matsusaka-jou",
			
			// Kansai
			"Odani-jou",
			"Hikone-jou",
			"Azuchi-jou",
			"Kannonji-jou",
			"Nijou-jou",
			"Osaka-jou",
			"Chihaya-jou",
			"Takeda-jou",
			"Sasayama-jou",
			"Akashi-jou",
			"Himeji-jou",
			"Akou-jou",
			"Takatori-jou",
			"Wakayama-jou",
			
			// Chuugoku
			"Tottori-jou",
			"Matsue-jou",
			"Gassantoda-jou",
			"Tsuwano-jou",
			"Tsuyama-jou",
			"Bitchuu Matsuyama-jou",
			"Ki-jou",
			"Okayama-jou",
			"Fukuyama-jou",
			"Yoshida-Kouriyama-jou",
			"Hiroshima-jou",
			"Iwakuni-jou",
			"Hagi-jou",
			
			// Shikoku
			"Tokushima-jou",
			"Takamatsu-jou",
			"Marugame-jou",
			"Imabari-jou",
			"Matsuyama-jou",
			"Yuzuki-jou",
			"Ouzu-jou",
			"Uwajima-jou",
			"Kouchi-jou",
			
			// Kyuushuu
			"Fukuoka-jou",
			"Ouno-jou",
			"Nagoya-jou",
			"Yoshinogari iseki",
			"Saga-jou",
			"Hirado-jou",
			"Shimabara-jou",
			"Kumamoto-jou",
			"Hitoyoshi-jou",
			"Funai-jou",
			"Oka-jou",
			"Obi-jou",
			"Kagoshima-jou",
			"Nakijin-jou",
			"Nakagusuku-jou",
			"Shuri-jou"
		];
		
		private var _game :Game;

		private var _CurrentCastle :int = 0;
		public function get CurrentCastle() :int { return _CurrentCastle; }
		
		public function get CurrentCastleName() :String { return CastleNames[_CurrentCastle]; }
		public function get CurrentCastlePower() :Number { return Math.pow(10, _CurrentCastle + 1); }
		
		override public function start(prefabArgs :Object, spawnArgs :Object) :void
		{
			_game = prefabArgs.game;
		}
		
		public function conquerCurrentCastle() :void
		{
			_game.handleSignal(Signals.CASTLE_CONQUERED, this, { castlePower : CurrentCastlePower } );
			
			_CurrentCastle += 1;
			if (_CurrentCastle >= CastleNames.length)
			{
				_CurrentCastle = CastleNames.length;
			}
		}
		
	} // class

} // package
