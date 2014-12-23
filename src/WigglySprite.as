package
{
    import org.flixel.*;

    public class WigglySprite extends FlxSprite{

        public var anchor:FlxPoint;
        public var power:Number = 2;
        public var _type:String;

        public function WigglySprite(x:Number, y:Number, sprite:Class=null, t:String=null){
            super(x, y, sprite);
            _type = t;
            anchor = new FlxPoint(x, y);
        }

        override public function update():void{
            this.anchor.y += .05;
            this.y = this.anchor.y;

            if(_type == "Mom") {
                this.anchor.x += .01;
                this.x = this.anchor.x;
            } else {
                this.anchor.x -= .01;
                this.x = this.anchor.x;
            }

            if (x < anchor.x + 2){
                x += Math.random()*power;
            } else if (x > anchor.x){
                x -= Math.random()*power;
            }
        }
    }
}
