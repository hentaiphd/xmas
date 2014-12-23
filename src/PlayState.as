package
{
    import org.flixel.*;

    public class PlayState extends FlxState
    {
        [Embed(source="../assets/new/zaguatica-Bold.otf", fontFamily="zaguatica-Bold", embedAsCFF="false")] public var GameFont:String;
        [Embed(source="../assets/new/mouse.png")] private var MouseImg:Class;
        [Embed(source="../assets/new/bg.png")] private var BgImg:Class;
        [Embed(source="../assets/new/Sisters.png")] private var FamilyImg:Class;
        [Embed(source="../assets/new/mombubble.png")] private var MomBubbleImg:Class;
        [Embed(source="../assets/new/sisbubble.png")] private var SisBubbleImg:Class;
        [Embed(source="../assets/new/tablechair.png")] private var ChairImg:Class;
        [Embed(source="../assets/new/tabletop.png")] private var TableTopImg:Class;
        [Embed(source="../assets/new/arrows.png")] private var ArrowImg:Class;
        [Embed(source="../assets/new/instruction.png")] private var InstructImg:Class;
        [Embed(source="../assets/new/throw2.png")] private var EndImg:Class;
        [Embed(source="../assets/new/auxpuces.mp3")] private var ClockSound:Class;

        public var bulbText:FlxText;
        public var timeText:FlxText;
        public var momText:FlxText;
        public var familyText:FlxText;
        public var msgText:FlxText;
        public var instruction:FlxSprite;
        public var momTextBg:WigglySprite;
        public var famTextBg:WigglySprite;

        public var mouse:FlxSprite;
        public var bulb:FlxRect;
        public var carried_bulb:Bulb;
        public var bg:FlxSprite;
        public var family:FlxSprite;
        public var player:Player;
        public var table:FlxSprite;
        public var chair:FlxSprite;
        public var box:FlxRect;
        public var mouse_rect:FlxRect;
        public var inst_arrow:FlxSprite;
        public var endbg:FlxSprite;

        public var frames:Number = 0;
        public var timeFrame:Number = 0;
        public var decorate:Boolean = false;
        public var bulbs_stuffed:Number = 0;
        public var mom_bubble_org:FlxPoint;
        public var fam_bubble_org:FlxPoint;
        public var full_bulbs:FlxGroup;
        public var bulb_positions:Array = [new FlxPoint(15,416), new FlxPoint(52,412), new FlxPoint(133,413), new FlxPoint(92, 385), new FlxPoint(145,404), new FlxPoint(61,385), new FlxPoint(107,413), new FlxPoint(69,342), new FlxPoint(117,340), new FlxPoint(3,400), new FlxPoint(92,376), new FlxPoint(23,389), new FlxPoint(88,365), new FlxPoint(95,415)]
        public var bubble_group:FlxGroup;

        public var mom_shake:Array = [true,true,true,true];
        public var fam_shake:Array = [true,true,true,true];

        public var stuff_lock:Boolean = false;
        public var mouse_lock:Boolean = false;
        public var instruction_lock:Boolean = false;

        public var cur_pos:Number = 0;

        override public function create():void
        {
            FlxG.bgColor = 0xff458A00;

            full_bulbs = new FlxGroup();

            bg = new FlxSprite(0,0);
            bg.loadGraphic(BgImg,false,false,640,480);
            add(bg);

            family = new FlxSprite(0,0);
            family.loadGraphic(FamilyImg,false,false,640,480)
            FlxG.state.add(family);

            bulbText = new FlxText(10,FlxG.height-20,FlxG.width,"");
            add(bulbText);
            timeText = new FlxText(10,FlxG.height-30,FlxG.width,"");
            //add(timeText);
            msgText = new FlxText(0,210,FlxG.width,"");
            //msgText.size = 16;
            msgText.alignment = "center";
            add(msgText);

            chair = new FlxSprite(0,FlxG.height-290);
            chair.loadGraphic(ChairImg,false,false,640,290)
            FlxG.state.add(chair);

            table = new FlxSprite(0,FlxG.height-96);
            table.loadGraphic(TableTopImg,false,false,640,96);
            FlxG.state.add(table);

            player = new Player(117,FlxG.height-chair.height-40);
            FlxG.state.add(player);

            if(FlxG.music == null){
                FlxG.playMusic(ClockSound);
            } else {
                FlxG.music.resume();
                if(!FlxG.music.active){
                    FlxG.playMusic(ClockSound);
                }
            }

            var inst:FlxText = new FlxText(10, FlxG.height-10, 500, "")
            FlxG.state.add(inst);

            bulb = new FlxRect(295,375,66,89);

            carried_bulb = new Bulb(0,0);
            FlxG.state.add(carried_bulb);
            carried_bulb.visible = false;

            instruction = new FlxSprite(bulb.x-170, bulb.y+50);
            instruction.loadGraphic(InstructImg,false,false,172,21);
            FlxG.state.add(instruction);
            instruction.visible = false;

            box = new FlxRect(494,398,110,86);

            bubble_group = new FlxGroup();

            momTextBg = new WigglySprite(60,0,null,"Mom");
            momTextBg.loadGraphic(MomBubbleImg,false,false,280,161)
            add(momTextBg);
            mom_bubble_org = new FlxPoint(280,161);
            bubble_group.add(momTextBg);
            momTextBg.alpha = .5;

            momText = new FlxText(momTextBg.x+53,momTextBg.y+40,220,"");
            add(momText);
            momText.setFormat("zaguatica-Bold",16,0xffffffff,"left");
            bubble_group.add(momText);
            momText.alpha = .5;

            famTextBg = new WigglySprite(FlxG.width-310,2,null,"Sis");
            famTextBg.loadGraphic(SisBubbleImg,false,false,280,161)
            add(famTextBg);
            fam_bubble_org = new FlxPoint(230,161);
            bubble_group.add(famTextBg);
            famTextBg.alpha = .5;

            familyText = new FlxText(famTextBg.x+15,famTextBg.y+40,220,"");
            add(familyText);
            familyText.setFormat("zaguatica-Bold",16,0xffffffff,"left");
            bubble_group.add(familyText);
            familyText.alpha = .5;

            mouse = new FlxSprite(FlxG.mouse.x,FlxG.mouse.y);
            mouse.loadGraphic(MouseImg,false,false,39,48);
            mouse.addAnimation("idle",[0],0,false);
            mouse.addAnimation("grab",[1],0,false);
            mouse.addAnimation("hold",[2],0,false);
            mouse.addAnimation("inactive",[3],0,false);
            mouse.play("idle");
            add(mouse);

            mouse_rect = new FlxRect(0,0,mouse.width,mouse.height);

            inst_arrow = new FlxSprite(box.x-120,box.y-80);
            inst_arrow.loadGraphic(ArrowImg,false,false,177,100);
            FlxG.state.add(inst_arrow);

            endbg = new FlxSprite(0,0);
            endbg.loadGraphic(EndImg,false,false,640,480);
            add(endbg)
            endbg.visible = false;
            endbg.alpha = 0;

            famTextBg.power = 5;
            momTextBg.power = 5;

        }

        override public function update():void
        {
            super.update();

            frames++;
            if(frames%50 == 0){
                timeFrame++;
            }

            if(timeFrame == 0){
                momText.text = "The man is an idiot. I'm not PRETENDING that she has asthma.";
            } else if(timeFrame == 3){
                familyText.text = "You're being irrational, Lisa! She's fine.";
            } else if(timeFrame == 5){
                momText.text = "He's psychotic--he couldn't even handle his sales job.";
            } else if(timeFrame == 8){
                familyText.text = "You haven't worked since she was born, so you're not one to talk.";
            } else if(timeFrame == 11){
                momText.text = "I'm taking care of Mia by myself. How could I work?";
            } else if(timeFrame == 14){
                familyText.text = "Well then, why don't you TRY getting along with Bret?";
            } else if(timeFrame == 17){
                momText.text = "He is abusive!";
            } else if (timeFrame == 20) {
                familyText.text = "You're not thinking about what's best for her--she should live with her father.";
            /*} else if(timeFrame == 23) {
                momText.text = "She should live with him? He can't even take care of himself.";
            } else if(timeFrame == 26){
                familyText.text = "You should go try and meet someone else then.";*/
            } else if(timeFrame == 23){
                momText.text = "You invited us here today, why are you attacking me like this?!";
            } else if(timeFrame == 26){
                familyText.text = "What you're doing doesn't look good and she needs a father."
            } else if(timeFrame == 29){
                momText.text = "He doesn't care about her. He flipped out the other day and broke her swing!";
            } else if(timeFrame == 32){
                familyText.text = "That's not what he told me.";
            } else if(timeFrame == 35){
                familyText.text = "You need a man to support you, Lisa. You and your daughter.";
            } else if(timeFrame == 38){
                momText.text = "We don't need him.";
            } else if(timeFrame == 41){
                familyText.text = "How are you going to put food on the table?";
            } else if(timeFrame == 44){
                momText.text = "I'll get a job. He also has to give me child support.";
            } else if(timeFrame == 47){
                familyText.text = "You're so selfish!";
            } else if(timeFrame == 50){
                momText.text = "How I raise my child is none of your business anyways!";
            }else if(timeFrame > 53){
                momText.text = "He's not a good parent!";
                familyText.text = "You're crazy Lisa! And you're a bad mother!";
            } else if(timeFrame == 56){
                endbg.visible = true;
                endbg.alpha += .01;
            }
            if(timeFrame == 59){
                FlxG.switchState(new TextState("GET OUT L ISA! AND TAKE THAT BRAT WITH YOU!","end 1"));
            }

            mouse.x = FlxG.mouse.x;
            mouse.y = FlxG.mouse.y;

            momText.x = momTextBg.x+56;
            momText.y = momTextBg.y+45;

            familyText.x = famTextBg.x+23;
            familyText.y = famTextBg.y+45;
            //bulbText.text = bulbs_stuffed.toString();
            //bulbText.size = 20;
            //bulbText.y = 200;

            for(var i:Number = 0; i < bubble_group.length; i++) {
                bubble_group.members[i].alpha += .0001;
            }

            if(!FlxG.mouse.pressed()) {
                if(!decorate) {
                    if(FlxG.overlap(carried_bulb,player,activeDecorate)) {
                        decorate = true;
                        player.holding = true;
                        this.carried_bulb.visible = false;
                        this.carried_bulb.holding = false;
                        inst_arrow.visible = false;

                        if(!instruction_lock) {
                            instruction.visible = true;
                            instruction_lock = true;
                        }
                    }
                }
                this.carried_bulb.visible = false;
                this.carried_bulb.holding = false;
                this.carried_bulb.x = box.x;
                this.carried_bulb.y = box.y;
            }

            for(i = 0; i < full_bulbs.length; i++) {
                if(player.held) {
                    full_bulbs.members[i].visible = true;
                    mouse.play("idle");
                }
            }

            mouse_rect.x = FlxG.mouse.x;
            mouse_rect.y = FlxG.mouse.y;
            if(player.stuffing == 4) {
                mouse.play("inactive");
                mouse.alpha = .5;
            } else {
                mouse.alpha = 1;
                if(bulb.overlaps(mouse_rect) || box.overlaps(mouse_rect)) {
                    if(FlxG.mouse.pressed()) {
                        if(bulb.overlaps(mouse_rect) && decorate) {
                            mouse.play("hold");
                        }
                        if(box.overlaps(mouse_rect)) {
                            mouse.play("hold");
                        }
                    } else {
                        if(box.overlaps(mouse_rect) || (bulb.overlaps(mouse_rect) && decorate)) {
                            mouse.play("grab");
                        }
                    }

                    if(bulb.overlaps(mouse_rect)) {
                        grabBulb();
                    } else if(box.overlaps(mouse_rect)) {
                        clickHeldBulb();
                    }
                } else if(FlxG.mouse.pressed()) {
                    mouse.play("hold");
                } else {
                    mouse.play("idle");
                }
            }

            if(decorate) {
                if(player.stuffing > 3) {
                    player.stuffing = 4;
                    player.held = false;
                    bulbs_stuffed++;

                    cur_pos = bulbs_stuffed;
                    if(cur_pos > bulb_positions.length || cur_pos < 0){
                        cur_pos = Math.floor(Math.random()*bulb_positions.length);
                    }
                    var b:Bulb = new Bulb(bulb_positions[bulbs_stuffed].x, bulb_positions[bulbs_stuffed].y);
                    full_bulbs.add(b);
                    FlxG.state.add(b);
                    b.stuffing = 3;
                    b.visible = false;

                    decorate = false;
                    instruction.visible = false;
                }
            }
            if(FlxG.mouse.justPressed()) {
                stuff_lock = false;
            }
        }

        public function grabBulb():void{
            if(FlxG.mouse.pressed()){
                if(decorate && !stuff_lock) {
                    player.stuffing++;
                    stuff_lock = true;
                }
            }
        }

        public function clickHeldBulb():void {
            if(FlxG.mouse.pressed()) {
                this.carried_bulb.visible = true;
                this.carried_bulb.holding = true;
            }
        }

        public function activeDecorate(b:Bulb,p:Player):Boolean {
            return true;
        }
    }
}
