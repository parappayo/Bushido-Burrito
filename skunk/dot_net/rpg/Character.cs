
using AttributeScore = int;

namespace Game.Sim
{
	public class Character
	{
		public enum Attributes
		{
			Might,
			Vitality,
			Focus,
			Lore,
			Leadership
		}

		private AttributeScore[] AttributeScores = new int[Enums.GetValues(typeof(Attributes)).Length];

		public AttributeScore GetAttributeModifier(Attributes attribute)
		{
			return 0;
		}

		public AttributeScore GetAttributeBaseScore(Attributes attribute)
		{
			return AttributeScores[attribute];
		}

		public AttributeScore GetAttributeScore(Attributes attribute)
		{
			return GetAttributeBaseScore(attribute) + GetAttributeModifier(attribute);
		}
	}
}