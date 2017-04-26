
function Range(start, end)
{
	this.start = start;
	this.end = end;
}

Range.prototype.delta = function ()
{
	return this.end - this.start;
}

function Curve()
{
	this.points = [];
}

Curve.prototype.scale = function (scale)
{
	this.points.forEach((currentValue, index, array) => {
		currentValue.x *= scale;
		currentValue.y *= scale;
	});
}

Curve.prototype.plot = function (canvasContext2D, points)
{
	if (this.points.length < 2) { return; }

	canvasContext2D.beginPath();
	canvasContext2D.moveTo(this.points[0].x, this.points[0].y);

	this.points.forEach((currentValue, index, array) => {
		canvasContext2D.lineTo(currentValue.x, currentValue.y);
	});

	canvasContext2D.stroke();
}

function ParametricFunction(x, y)
{
	this.x = x;
	this.y = y;
}

ParametricFunction.prototype.generateCurve = function (range, stepCount)
{
	var curve = new Curve();

	var t = range.start;
	var dt = range.delta() / stepCount;
	var previousPoint = { x: this.x(t), y: this.y(t) };

	while (stepCount > 0) {
		stepCount--;

		t += dt;
		var point = {
			x: previousPoint.x + this.x(t),
			y: previousPoint.y + this.y(t)
		};

		curve.points.push(point);
		previousPoint = point;
	}

	return curve;
}

ParametricFunction.prototype.plot = function (canvasContext2D, range, stepCount, scale)
{
	var curve = this.generateCurve(range, stepCount);
	curve.scale(scale);
	curve.plot(canvasContext2D, curve);
}

function plotSpiral(canvasContext2D, range, stepCount, scale)
{
	var func = new ParametricFunction(
		(t) => { return Math.cos(t) * t },
		(t) => { return Math.sin(t) * t }
	);

	func.plot(canvasContext2D, range, stepCount, scale);
}

// https://en.wikipedia.org/wiki/Euler_spiral
function plotEulerSpiral(canvasContext2D, range, stepCount, scale)
{
	var dt = range.delta() / stepCount;

	var func = new ParametricFunction(
		(t) => { return Math.cos(t * t) * dt },
		(t) => { return Math.sin(t * t) * dt }
	);

	func.plot(canvasContext2D, range, stepCount, scale);
}

// https://en.wikipedia.org/wiki/Butterfly_curve_(transcendental)
function plotButterflyCurve(canvasContext2D, range, stepCount, scale)
{
	var func = new ParametricFunction(
		(t) => { return Math.sin(t) * (Math.exp(Math.cos(t)) - 2 * Math.cos(4 * t) - Math.pow(Math.sin(t / 12), 5)); },
		(t) => { return Math.cos(t) * (Math.exp(Math.cos(t)) - 2 * Math.cos(4 * t) - Math.pow(Math.sin(t / 12), 5)); }
	);

	func.plot(canvasContext2D, range, stepCount, scale);
}
