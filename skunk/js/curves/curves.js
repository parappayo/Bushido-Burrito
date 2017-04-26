
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

Curve.prototype.translate = function (x, y)
{
	this.points.forEach((currentValue, index, array) => {
		currentValue.x += x;
		currentValue.y += y;
	});
}

Curve.prototype.plot = function (canvasContext2D)
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

	if (this.isCumulativeCurve) {
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

	} else {
		while (stepCount > 0) {
			stepCount--;

			t += dt;
			var point = {
				x: this.x(t),
				y: this.y(t)
			};

			curve.points.push(point);
		}
	}


	return curve;
}

ParametricFunction.Spiral = function ()
{
	return new ParametricFunction(
			(t) => { return Math.cos(t) * t },
			(t) => { return Math.sin(t) * t }
		);
}

// https://en.wikipedia.org/wiki/Euler_spiral
ParametricFunction.EulerSpiral = function (range, stepCount)
{
	var dt = range.delta() / stepCount;

	var func = new ParametricFunction(
			(t) => { return Math.cos(t * t) * dt },
			(t) => { return Math.sin(t * t) * dt }
		);

	func.isCumulativeCurve = true;

	return func;
}

// https://en.wikipedia.org/wiki/Butterfly_curve_(transcendental)
ParametricFunction.ButterflyCurve = function ()
{
	return new ParametricFunction(
		(t) => { return Math.sin(t) * (Math.exp(Math.cos(t)) - 2 * Math.cos(4 * t) - Math.pow(Math.sin(t / 12), 5)); },
		(t) => { return Math.cos(t) * (Math.exp(Math.cos(t)) - 2 * Math.cos(4 * t) - Math.pow(Math.sin(t / 12), 5)); }
	);
}

function plotCurve(canvasContext2D, params)
{
	if (!params.parametricFunc) {
		return;
	}

	var curve = params.parametricFunc.generateCurve(params.range, params.stepCount);

	if (params.scale) {
		curve.scale(params.scale);
	}
	if (params.offset) {
		curve.translate(params.offset.x, params.offset.y);
	}

	curve.plot(canvasContext2D);
}
