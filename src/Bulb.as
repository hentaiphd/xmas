package
{
    import org.flixel.*;

    public class Bulb extends FlxSprite{
        [Embed(source="../assets/new/bulb.png")] private var ImgBulb:Class;

        public var held:Boolean = false;
        public var stuffing:Number = 0;
        public var holding:Boolean = false;

        public function Bulb(x:Number,y:Number):void{
            super(x,y)
            this.loadGraphic(ImgBulb,false,false,66,89);
            this.addAnimation("empty",[0],0,false);
            this.addAnimation("1",[1],0,false);
            this.addAnimation("2",[2],0,false);
            this.addAnimation("3",[3],0,false);
        }

        override public function update():void{
            super.update();
            if(holding) {
                this.x = FlxG.mouse.x;
                this.y = FlxG.mouse.y;
            }

            if(this.stuffing <= 0) {
                this.play("empty");
            } else if(this.stuffing == 1) {
                this.play("1");
            } else if(this.stuffing == 2) {
                this.play("2");
            } else if(this.stuffing == 3) {
                this.play("3");
            }
        }
    }
}