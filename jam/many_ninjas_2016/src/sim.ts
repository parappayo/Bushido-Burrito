
export class Population
{
	static NUM_RANKS :number = 12;

	private growthRate :number = 1;

	ranks :Array<number>;

	constructor()
	{
		this.ranks = new Array<number>();
		for (var i :number = 0; i < Population.NUM_RANKS; i++) {
			this.ranks.push(0);
		}
	}

	tick()
	{
		this.ranks[0] += this.growthRate;
	}

	total() :number
	{
		var total :number = 0;
		for (var rank of this.ranks) {
			total += rank;
		}
		return total;
	}
}

export class Settlement
{
	static all :Array<Settlement> = [];

	population :Population = new Population();

	constructor()
	{
		Settlement.all.push(this);
	}

	tick()
	{
		this.population.tick();
	}
}

export class Sim
{
	tick()
	{
		for (var settlement of Settlement.all) {
			settlement.tick();
		}
	}
}
