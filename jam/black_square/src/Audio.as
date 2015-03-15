package  
{
	import flash.media.Sound;
	import flash.media.SoundTransform;	
	import flash.media.SoundChannel;		
	
	public class Audio 
	{	
		[Embed(source="../assets/Audio/Kremlin_Bells.mp3")]
		private static var kremlinBellsSound:Class;
		public static var kremlinBells:Sound;
		
		[Embed(source="../assets/Audio/BlackSquare_MX_1.mp3")]
		private static var mx1Sound:Class;
		public static var mx1Music:Sound;
		[Embed(source="../assets/Audio/BlackSquare_Death_Sting.mp3")]
		private static var deathSound:Class;
		public static var deathMusic:Sound;
		[Embed(source="../assets/Audio/BlackSquare_Revelry.mp3")]
		private static var revelrySound:Class;
		public static var revelryMusic:Sound;		
		
		[Embed(source="../assets/Audio/Ghost_Pixels_Theme.mp3")]
		private static var ghostPxsSound:Class;
		public static var ghostPxs:Sound;
		
		[Embed(source="../assets/Audio/UI_Direction.mp3")]
		private static var radioSound:Class;
		public static var radio:Sound;
		[Embed(source="../assets/Audio/Pickup_Health.mp3")]
		private static var pickupHealthSound:Class;
		public static var pickupHealth:Sound;
		[Embed(source="../assets/Audio/Pickup_Weapon.mp3")]
		private static var pickupWeaponSound:Class;
		public static var pickupWeapon:Sound;
		[Embed(source="../assets/Audio/Box_Move_01.mp3")]
		private static var boxMoveSound:Class;
		public static var boxMove:Sound;		
		
		[Embed(source="../assets/Audio/Bullet_Impact_Concrete_01.mp3")]
		private static var bulletConcrete1Sound:Class;
		public static var bulletConcrete1:Sound;		
		[Embed(source="../assets/Audio/Bullet_Impact_Concrete_02.mp3")]
		private static var bulletConcrete2Sound:Class;
		public static var bulletConcrete2:Sound;
				
		[Embed(source="../assets/Audio/Bullet_Impact_Enemy_02.mp3")]
		private static var bulletEnemy2Sound:Class;
		public static var bulletEnemy2:Sound;
		[Embed(source="../assets/Audio/Bullet_Impact_Enemy_03.mp3")]
		private static var bulletEnemy3Sound:Class;
		public static var bulletEnemy3:Sound;
		
		[Embed(source="../assets/Audio/Bullet_Impact_Metal_01.mp3")]
		private static var bulletMetal1Sound:Class;
		public static var bulletMetal1:Sound;		
		[Embed(source="../assets/Audio/Bullet_Impact_Metal_02.mp3")]
		private static var bulletMetal2Sound:Class;
		public static var bulletMetal2:Sound;
		
		[Embed(source="../assets/Audio/Enemy_Dmg_01.mp3")]
		private static var enemyDmg1Sound:Class;
		public static var enemyDmg1:Sound;
		[Embed(source="../assets/Audio/Enemy_Dmg_03.mp3")]
		private static var enemyDmg3Sound:Class;
		public static var enemyDmg3:Sound;	
		
		[Embed(source="../assets/Audio/Explo_Barrel_01.mp3")]
		private static var barrelExplo1Sound:Class;
		public static var barrelExplo1:Sound;
		[Embed(source="../assets/Audio/Explo_Barrel_03.mp3")]
		private static var barrelExplo3Sound:Class;
		public static var barrelExplo3:Sound;
		
		[Embed(source="../assets/Audio/Mine_Beep.mp3")]
		private static var mineBeepSound:Class;
		public static var mineBeep:Sound;
		[Embed(source="../assets/Audio/Tank_Fire_03.mp3")]
		private static var mineExploSound:Class;
		public static var mineExplo:Sound;
		
		[Embed(source="../assets/Audio/Gun_Fire_01.mp3")]
		private static var gunFire1Sound:Class;
		public static var gunFire1:Sound;
		[Embed(source="../assets/Audio/Gun_Fire_02.mp3")]
		private static var gunFire2Sound:Class;
		public static var gunFire2:Sound;
		[Embed(source="../assets/Audio/Gun_Fire_03.mp3")]
		private static var gunFire3Sound:Class;
		public static var gunFire3:Sound;

		[Embed(source="../assets/Audio/Tank_Turret_Head.mp3")]
		private static var tankTurretSound:Class;
		public static var tankTurret:Sound;
		[Embed(source="../assets/Audio/Tank_Fire_01.mp3")]
		private static var tankFireSound:Class;
		public static var tankFire:Sound;
		[Embed(source="../assets/Audio/Tank_Fire_02.mp3")]
		private static var tankHitSound:Class;
		public static var tankHit:Sound;
		[Embed(source="../assets/Audio/Enemy_Death_03.mp3")]
		private static var stalinHitSound:Class;
		public static var stalinHit:Sound;
		[Embed(source="../assets/Audio/Stalin_Death_01.mp3")]
		private static var stalinDeathSound:Class;
		public static var stalinDeath:Sound;
		
		public static var gunFireSoundList:Array;
		public static var bulletConcreteSoundList:Array;
		public static var bulletEnemySoundList:Array;
		public static var bulletMetalSoundList:Array;
		public static var barrelExploSoundList:Array;
		public static var enemyDmgSoundList:Array;
		
		public static const VOLUME_MUSIC:Number = 1.5;
		public static const VOLUME_SFX:Number = 0.4;
		public static const VOLUME_SFX_LOUD:Number = 0.8;
		
		public static function init():void
		{
			kremlinBells = create(kremlinBellsSound);
			mx1Music = create(mx1Sound);
			deathMusic = create(deathSound);
			revelryMusic = create(revelrySound);
			ghostPxs = create(ghostPxsSound);
			radio = create(radioSound);
			pickupHealth = create(pickupHealthSound);
			pickupWeapon = create(pickupWeaponSound);
			boxMove = create(boxMoveSound);
			
			gunFire1 = create(gunFire1Sound);
			gunFire2 = create(gunFire2Sound);
			gunFire3 = create(gunFire3Sound);
			gunFireSoundList = new Array(gunFire1, gunFire2, gunFire3);
			
			bulletConcrete1 = create(bulletConcrete1Sound);
			bulletConcrete2 = create(bulletConcrete2Sound);
			bulletConcreteSoundList = new Array(bulletConcrete1, bulletConcrete2);
			
			bulletEnemy2 = create(bulletEnemy2Sound);
			bulletEnemy3 = create(bulletEnemy3Sound);
			bulletEnemySoundList = new Array(bulletEnemy2, bulletEnemy3);
			
			bulletMetal1 = create(bulletMetal1Sound);
			bulletMetal2 = create(bulletMetal2Sound);
			bulletMetalSoundList = new Array(bulletMetal1, bulletMetal2);
			
			barrelExplo1 = create(barrelExplo1Sound);
			barrelExplo3 = create(barrelExplo3Sound);
			barrelExploSoundList = new Array(barrelExplo1, barrelExplo3);
			
			enemyDmg1 = create(enemyDmg1Sound);
			enemyDmg3 = create(enemyDmg3Sound);	
			enemyDmgSoundList = new Array(enemyDmg1, enemyDmg3);
			
			mineBeep = create(mineBeepSound);
			mineExplo = create(mineExploSound);
			
			tankTurret = create(tankTurretSound);
			tankHit = create(tankHitSound);
			tankFire = create(tankFireSound);
			stalinHit = create(stalinHitSound);
			stalinDeath = create(stalinDeathSound);
		}
		
		private static function create(soundClass:Class):Sound
		{
			var sound:Sound = new soundClass();
			sound.play(0, 0, new SoundTransform(0));
			return sound;
		}
	}
}