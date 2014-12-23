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
        [Embed(source="../assets/new/downarrow.png")] private var DownArrowImg:Class;
        [Embed(source="../assets/new/sidearrow.png")] private var SideArrowImg:Class;
        [Embed(source="../assets/new/instruction.png")] private var InstructImg:Class;
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
        public var side_arrow:FlxSprite;
        public var down_arrow:FlxSprite;

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
            mouse.play("idle");
            add(mouse);

            mouse_rect = new FlxRect(0,0,mouse.width,mouse.height);

            down_arrow = new FlxSprite(box.x+(box.width/2),box.y-70);
            down_arrow.loadGraphic(DownArrowImg,false,false,36,55);
            FlxG.state.add(down_arrow);

            side_arrow = new FlxSprite(bulb.x+140,bulb.y);
            side_arrow.loadGraphic(SideArrowImg,true,false,55,36);
            FlxG.state.add(side_arrow);

        }

        override public function update():void
        {
            super.update();

            frames++;
            if(frames%50 == 0){
                timeFrame++;
            }

            if(timeFrame > 0){
                momText.text = "The man is an idiot. I'm not PRETENDING that she has asthma.";
            }

            if(timeFrame > 3){
                familyText.text = "You're being irrational, Lisa! She's fine.";
            }

            if(timeFrame > 5){
                momText.text = "He's psychotic--he couldn't even handle his sales job.";
            }

            if(timeFrame > 7){
                familyText.text = "You haven't worked since she was born, so you're not one to talk.";
            }

            if(timeFrame > 13){
                momText.text = "I'm taking care of Mia by myself. How could I work?";
            }

            if(timeFrame > 16){
                familyText.text = "Well then, why don't you TRY getting along with Bret?";
            }

            if(timeFrame > 20){
                momText.text = "He is abusive!";
            }

            if(timeFrame > 25){
                //start shake
                familyText.text = "You need a man to support you, Lisa. You and your daughter.";
            }

            if(timeFrame > 30){
                momText.text = "We don't need him.";
            }

            if(timeFrame > 35){
                familyText.text = "How are you going to put food on the table?";
            }

            if(timeFrame > 40){
                momText.text = "I'll get a job. He also has to give me child support.";
            }

            if(timeFrame > 45){
                familyText.text = "You're so selfish!";
            }

            if(timeFrame > 50){
                momText.text = "How I raise my child is none of your business anyways!";
                familyText.text = "You're not thinking about what's best for her--she should live with her father.";
            }

            if(timeFrame > 53){
                momText.text = "He's not a good parent! I'm her mother!";
                familyText.text = "You're crazy Lisa! And you're raising a brat!";
            }

            if(timeFrame > 56){
                momText.text = "How can you say that about a child--you're the crazy one!";
            }

            if(timeFrame == 59){
                FlxG.switchState(new TextState("GET OUT L ISA! AND TAKE THAT BRAT WITH YOU!","end 1"));
            }

            mouse.x = FlxG.mouse.x;
            mouse.y = FlxG.mouse.y;
            famTextBg.power = 5;
            momTextBg.power = 5;

            momText.x = momTextBg.x+56;
            momText.y = momTextBg.y+45;

            familyText.x = famTextBg.x+23;
            familyText.y = famTextBg.y+45;
            //bulbText.text = bulbs_stuffed.toString();
            //bulbText.size = 20;
            //bulbText.y = 200;

            if(msgText.text != ""){
                if(timeFrame%5 == 0){
                    msgText.text = "";
                }
            }

            for(var i:Number = 0; i < bubble_group.length; i++) {
                bubble_group.members[i].alpha += .0001;
            }

            if(!FlxG.mouse.pressed() && !decorate) {
                if(FlxG.overlap(carried_bulb,player,activeDecorate)) {
                    decorate = true;
                    side_arrow.visible = false;
                    player.holding = true;
                    this.carried_bulb.visible = false;
                    this.carried_bulb.holding = false;

                    if(!instruction_lock) {
                        instruction.visible = true;
                        instruction_lock = true;
                    }
                }
            }
            if(!FlxG.mouse.pressed()) {
                this.carried_bulb.visible = false;
                this.carried_bulb.holding = false;
                this.carried_bulb.x = box.x;
                this.carried_bulb.y = box.y;
            }

            for(i = 0; i < full_bulbs.length; i++) {
                if(player.held) {
                    full_bulbs.members[i].visible = true;
                }
            }

            mouse_rect.x = FlxG.mouse.x;
            mouse_rect.y = FlxG.mouse.y;
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

            if(decorate) {
                //FlxG.overlap(bulb,mouse,clickHeldBulb);
                if(player.stuffing > 3) {
                    //bulb.x = Math.random()*152+19;
                    //bulb.y = Math.random()*119+261;
                    player.stuffing = 4;
                    player.held = false;
                    bulbs_stuffed++;

                    var cur_pos:Number = bulbs_stuffed;
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
                down_arrow.visible = false;
            }
        }

        public function activeDecorate(b:Bulb,p:Player):Boolean {
            return true;
        }
    }
}
