package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.GraphicsGradientFill;
	import flash.display.Sprite;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.system.System;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author mhtsu
	 */
	public class Main extends Sprite 
	{
		private var panels:Vector.<Bitmap> = new Vector.<Bitmap>; //パネルの画像
		private var pFlag:Vector.<int> = new Vector.<int>(5000,0); //パネルのフラグ(開けられているか(1)、旗が立っているか(2))
		private var pData:Vector.<int> = new Vector.<int>(5000, 0);; //パネルのデータ (1,2,3等)
		private var flags:Vector.<Bitmap> = new Vector.<Bitmap> //マーク旗の画像
		private var mode:int = new int(0); //メニューやゲーム画面等のフラグ
		
		private var mx:int = new int;//マウス座標
		private var my:int = new int;
		
		[Embed(source = "../lib/start.png")]private const img1:Class;
		private var LstartBtn:Bitmap = new img1;
		private var startBtn:Sprite = new Sprite; //スタートボタン画像
		private var btnFlag:int = new int(0); //どのボタンの上か 0=無選択
		[Embed(source = "../lib/panel.png")]private const img2:Class; //パネル
		private var Lpanel:Bitmap = new img2; //パネルビットマップ
		private var panel:Sprite = new Sprite;
		private var panelFlag:int = new int(-1); //カーソルパネル　-1=無選択
		[Embed(source = "../lib/flag.png")]private const img3:Class; //旗画像
		private var flag:Bitmap = new img3; //旗ビットマップ
		
		
		private var debugTxt:TextField = new TextField; 　//デバッグ用
		
		//番号
		[Embed(source = "../lib/0.png")]private static var num0:Class;
		[Embed(source = "../lib/1.png")]private static var num1:Class;
		[Embed(source = "../lib/2.png")]private static var num2:Class;
		[Embed(source = "../lib/3.png")]private static var num3:Class;
		[Embed(source = "../lib/4.png")]private static var num4:Class;
		[Embed(source = "../lib/5.png")]private static var num5:Class;
		[Embed(source = "../lib/6.png")]private static var num6:Class;
		[Embed(source = "../lib/7.png")]private static var num7:Class;
		[Embed(source = "../lib/8.png")]private static var num8:Class;
		[Embed(source = "../lib/9.png")]private static var num9:Class;
		private var num:Vector.<Bitmap> = new Vector.<Bitmap> //番号Bitmap
		private var nums:Vector.<BitmapData> = new Vector.<BitmapData> //番号BitmapData
		private var number:Bitmap = new Bitmap;//番号板
		
		//
		[Embed(source = "../lib/bomb.png")]private const img4:Class;
		private var bombB:Bitmap = new img4; //爆弾
		private var bomb:BitmapData = new BitmapData(32, 32);
		
		private var sizeX:int = new int(10);//横
		private var sizeY:int = new int(10);//縦
		private var bombNum:int = new int(5);//ボムの数
		
		//メニュー
		private var selR1:Sprite = new Sprite;
		private var selR2:Sprite = new Sprite;
		private var selL1:Sprite = new Sprite;
		private var selL2:Sprite = new Sprite;
		private var MASU:TextField = new TextField; //マス数説明
		private var MASU_num:TextField = new TextField; //数値
		private var BOMU:TextField = new TextField; //ボム数説明
		private var BOMU_num:TextField = new TextField; //数値
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			stage.addEventListener(MouseEvent.CLICK, mouseClick, false, 0, true);
			startBtn.addEventListener(MouseEvent.CLICK, startBtnClick, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown, false, 0, true);
			selR1.addEventListener(MouseEvent.CLICK, selR1Click, false, 0, true);
			selR2.addEventListener(MouseEvent.CLICK, selR2Click, false, 0, true);
			selL1.addEventListener(MouseEvent.CLICK, selL1Click, false, 0, true);
			selL2.addEventListener(MouseEvent.CLICK, selL2Click, false, 0, true);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			//スタートボタン
			startBtn.addChild(LstartBtn);
			startBtn.x = 100;
			startBtn.y = 200;
			startBtn.visible = false;
			startBtn.buttonMode = true; //ボタンモード
			stage.addChild(startBtn); //スタートボタン追加
			
			//debugTxt
			debugTxt.width = 400;
			debugTxt.height = 300;
			debugTxt.mouseEnabled = false;
			debugTxt.text = "ロード中...";
			stage.addChildAt(debugTxt,1);
			
			//番号画像
			var i:int = new int;
			for (i = 0; i < 10; i++) {
				num[i] = new Main["num" + i]; //画像作成
				nums[i] = new BitmapData(30, 30);
				nums[i].draw(num[i]);
			}
			
			//爆弾
			bombB.width = 32;
			bombB.height = 32;
			bomb.draw(bombB,new Matrix(1.5,0,0,1.5)); //ビットマップデータ化
			
			stage.addChildAt(number, 0); //追加
			
			//メニュー画像
			var g:Graphics = selR1.graphics;
			
			//三角形　右向き
			g.lineStyle(1, 0x000000, 1);
			g.beginFill(0x999999, 1);
			g.moveTo(0, 0);
			g.lineTo(10, 5);
			g.lineTo(0, 10);
			g.endFill()
			
			selR2.graphics.copyFrom(g); //コピー
			
			selR1.x = 190;
			selR1.y = 50;
			selR1.buttonMode = true;
			stage.addChild(selR1);
			
			selR2.x = 190;
			selR2.y = 100;
			selR2.buttonMode = true;
			stage.addChild(selR2);
			
			//左
			g = selL1.graphics;
			g.clear();
			
			//三角形　左向き
			g.lineStyle(1, 0x000000, 1);
			g.beginFill(0x999999, 1);
			g.moveTo(10, 0);
			g.lineTo(0, 5);
			g.lineTo(10, 10);
			g.endFill()
			
			selL2.graphics.copyFrom(g); //コピー
			
			selL1.x = 100;
			selL1.y = 50;
			selL1.buttonMode = true;
			stage.addChild(selL1);
			
			selL2.x = 100;
			selL2.y = 100;
			selL2.buttonMode = true;
			stage.addChild(selL2);
			
			//メニューテキスト
			MASU.x = 100;
			MASU.y = 25;
			MASU.text = "縦　及び　横マス数";
			MASU.mouseEnabled = false;
			stage.addChild(MASU);
			
			MASU_num.x = 120;
			MASU_num.y = 45;
			MASU_num.text = "" + sizeX;
			MASU_num.mouseEnabled = false;
			stage.addChild(MASU_num);
			
			BOMU.x = 100;
			BOMU.y = 75;
			BOMU.text = "ボム数"
			BOMU.mouseEnabled = false;
			stage.addChild(BOMU);
			
			BOMU_num.x = 120;
			BOMU_num.y = 95;
			BOMU_num.text = "" + bombNum;
			BOMU_num.mouseEnabled = false;
			stage.addChild(BOMU_num);
			
		}
		
		private function onEnterFrame(e:Event):void {
			
			//マウス座標取得
			mx = stage.mouseX;
			my = stage.mouseY;
			
			if (mode == 0) { //メニューセット
				debugTxt.text = "loading..";
				startBtn.visible = true; //ボタン表示
				debugTxt.text = "";
				mode = 1;
			}else if (mode == 1) { //メニュー
				MASU_num.text = "" + sizeX;
				BOMU_num.text = "" + bombNum;
			}else if (mode == 2) { //ゲームセット
				setPanel(sizeX, sizeY, bombNum);
				panelLoad(); //パネル画像作成
				mode = 3;
				debugTxt.text = "";
				
			}else if (mode == 3) { //ゲーム画面
				debugTxt.text = "mでメニューへ";
			}else if (mode == 4) { //ゲームクリア
				debugTxt.text = "game clear\n" +
								"rキーでリセット";
			}else if (mode == 5) { //ゲームオーバー
				debugTxt.text = "game over\n" +
								"rキーでリセット";
			}
		}
		
		//パネル作成(pDataに代入及び画像セット)　sizeX,sizeY = パネル数、　bombs = 爆弾の数
		private function setPanel(sizeX:uint, sizeY:uint, bombs:uint):void {
			
			pFlag = new Vector.<int>(5000, 0);
			pData = new Vector.<int>(5000, 0);
			
			var x:int = new int;//座標
			var y:int = new int;
			var onex:int = new int; //一パネルの横サイズ
			onex = 400 / sizeX;
			var oney:int = new int; //一パネルの縦サイズ
			oney = 300 / sizeY;
			var one:int = new int; //１パネルの大きさ(最終)
			one = (onex > oney) ? oney : onex; //画面に入れるため小さい方を代入
			var index:int = new int; //繰り返し中のパネル位置
			var i:int = new int; //繰り返し
			var left:Boolean = new Boolean;//超えフラグ(無駄な部分を調べないため)
			var right:Boolean = new Boolean;
			var up:Boolean = new Boolean;
			var down:Boolean = new Boolean;
			
			var numberD:BitmapData = new BitmapData(sizeX * 32, sizeY * 32);
			
			//爆弾セット
			for (i = 0; i < bombs; i++){
				while (true) {
					index = Math.random() * (sizeX * sizeY);//爆弾の位置を適当に決める
					if (pData[index]　!= -1) { //爆弾じゃなければ
						pData[index] = -1; //爆弾セッツ
						break;
					}
				}
			}
			
			//pDataセット及び画像セット
			for (y = 0; y < sizeY; y++) {
				for (x = 0; x < sizeX; x++) {
					
					index = sizeX * y + x //あらかじめ代入
					
					pData[index] = (pData[index] == -1) ? -1 : 0; //初期化
					
					//pData
					//周り爆弾調べ
					up = (y == 0); //上禁止ー
					down = (y == sizeY - 1);
					right = (x == sizeX - 1);
					left = (x == 0);
					//左上
					if(pData[index] != -1){
						if (!up && !left) {
							if (pData[index - sizeX - 1] == -1) {//爆弾しらべ
								pData[index]++; //数字たす
							}
						}
						//上
						if (!up) {
							if (pData[index - sizeX] == -1) {//爆弾しらべ
								pData[index]++; //数字たす
							}
						}
						//右上
						if (!up && !right) {
							if (pData[index - sizeX + 1] == -1) {//爆弾しらべ
								pData[index]++; //数字たす
							}
						}
						//右
						if (!right) {
							if (pData[index + 1] == -1) {//爆弾しらべ
								pData[index]++; //数字たす
							}
						}
						//右下
						if (!right && !down) {
							if (pData[index + sizeX + 1] == -1) {//爆弾しらべ
								pData[index]++; //数字たす
							}
						}
						//下
						if (!down) {
							if (pData[index + sizeX] == -1) {//爆弾しらべ
								pData[index]++; //数字たす
							}
						}
						//左下
						if (!left && !down) {
							if (pData[index + sizeX - 1] == -1) {//爆弾しらべ
								pData[index]++; //数字たす
							}
						}
						//左
						if (!left) {
							if (pData[index - 1] == -1) {//爆弾しらべ
								pData[index]++; //数字たす
							}
						}
					}
					
					
					//番号板作成
					if (pData[index] > 0) {
						numberD.copyPixels(nums[pData[index]], nums[pData[index]].rect, new Point(x * 32, y * 32 + 1));
					}else if (pData[index] == -1) {
						numberD.copyPixels(bomb, bomb.rect, new Point(x * 32 + 1, y * 32 + 1));
					}
					
				}
				
			}
			
			number.bitmapData = numberD;
			number.width = one * sizeX;//番号板のサイズ調整
			number.height = one * sizeY;
			number.x = (200 - ((sizeX * one) / 2))
			
		}
		
		private function mouseClick(e:MouseEvent):void {//マウスクリック
			
			//どこが選択されているか
			if (mode == 3) {//ゲーム画面の時
				var i:int = new int;
				var i2:int = new int;
				var onex:int = new int; //一パネルの横サイズ
				onex = 400 / sizeX;
				var oney:int = new int; //一パネルの縦サイズ
				oney = 300 / sizeY;
				var one:int = new int; //１パネルの大きさ(最終)
				one = (onex > oney) ? oney : onex; //画面に入れるため小さい方を代入
				
				for (i = 0; i < sizeY; i++) {
					for (i2 = 0; i2 < sizeX; i2++) {
						if (sqAt2(mouseX, mouseY, i2 * one + (200 - ((sizeX * one) / 2)), i * one, one, one)) {
							pFlag[i * sizeX + i2] = 1; //フラグ建てる
							Fill0(i2, i);
							panelCheck(); //パネルチェック
							scanGame(pData[i * sizeX + i2]);
							return;
						}
					}
				}
				
			}
		}
		
		private function startBtnClick(e:MouseEvent):void { //スタートボタンクリック
			startBtn.visible = false;//非表示
			mode = 2;//ゲームセット
			debugTxt.text = "パネル作成中"
			
			MASU.visible = false;
			MASU_num.visible = false;
			BOMU.visible = false;
			BOMU_num.visible = false;
			selR1.visible = false;
			selR2.visible = false;
			selL1.visible = false;
			selL2.visible = false;
			number.visible = true;
		}
		
		private function sqAt2(x:int, y:int, x2:int, y2:int, xS2:int, yS2:int):Boolean { //四角と点
			return x >= x2 && x <= x2 + xS2 && y >= y2 && y <= y2 + yS2
		}
		
		private function panelCheck():void { //パネルの表示　非表示管理
			var i:int = new int;
			var i2:int = new int;
			for (i = 0; i < sizeY; i++) {
				for (i2 = 0; i2 < sizeX; i2++) {
					if(pFlag[i * sizeX + i2] == 1){
						panels[i * sizeX + i2].visible = false;
					}else {
						panels[i * sizeX + i2].visible = true;
						if (pFlag[i * sizeX + i2] == 2) { //旗
							
						}
					}
				}
			}
		}
		
		private function Fill0(x:int, y:int):void { //0を塗りつぶす
			
			if (pData[sizeX * y + x] != 0) return; //0以外は無視
			
			var i:int = new int;
			
			var buffer:Array = new Array;
			buffer.push(new Point(x, y)); //最初のポイント入れておく
			
			var point:Point = new Point;//一時ポイント格納変数
			
			while (buffer.length) { //ポイントがあるだけ繰り返す
				
				point = buffer.shift(); 　//ポイント取り出す
				
				var LeftX:uint = new uint;
				var RightX:uint = new uint;
				
				for (LeftX = point.x; LeftX > 0; LeftX--) { //左端を探す
					if (pData[sizeX * point.y + LeftX] != 0) break; //0じゃない場合
				}
				
				for (RightX = point.x; RightX < sizeX - 1; RightX++) { //右端
					if (pData[sizeX * point.y + RightX] != 0) {
						break; //0じゃない場合、ループを抜ける
					}
				}
				
				
				for (i = 0; i <= RightX - LeftX; i++) { //その範囲のパネルを開ける
					pFlag[sizeX * point.y + LeftX + i] = 1;
					panels[sizeX * point.y + LeftX + i].visible = false;
				}
				
				if (point.y != 0) scanLine(point.x, point.y - 1, LeftX, RightX, buffer); //上を捜索
				if (point.y != sizeY - 1) scanLine(point.x, point.y + 1, LeftX, RightX, buffer); //下を
				
			}
			
			
			for (i = 0; i < sizeX*sizeY; i++) {
				if (pData[i] == 0 && pFlag[i] == 1 ) { //0でパネルが開いている
					if (i + sizeX < sizeX * sizeY) { //範囲を越してなければ
						pFlag[i + sizeX] = 1; //下
					}
					if (i - sizeX >= 0) { //越してなければ
						pFlag[i - sizeX] = 1; //上
					}
					if (i % sizeX > 0){ //
						if (i - sizeX - 1 >= 0) {
							pFlag[i - sizeX - 1] = 1; //左上
						}
						if (i + sizeX - 1 < 400) {
							pFlag[i + sizeX - 1] = 1; //左下
						}
					}
					if (i % sizeX < sizeX　- 1) {
						if (i - sizeX + 1 >= 0) {
							pFlag[i - sizeX + 1] = 1; //右上
						}
						if (i + sizeX  < sizeX * sizeY) {
							pFlag[i + sizeX + 1] = 1; //右下
						}
					}
				}
				
			}
			
			
		}
		
		private function scanLine(x:int, y:int, LeftX:int, RightX:int, buffer:Array):void {
			
			while(LeftX <= RightX){
				for (; LeftX <= RightX; LeftX++) {
					if (pData[sizeX * y + LeftX] == 0 && pFlag[sizeX * y + LeftX] == 0) break; //0を見つけたら出る
				}
				
				if (RightX < LeftX) {
					break; //はみ出したら
				}
				
				for (; LeftX <= RightX; LeftX++) {
					if (pData[sizeX * y + LeftX] != 0) break;
				}
				
				buffer.push(new Point(LeftX - 1, y));
				
			}
		}
		
		private function scanGame(flag:int):void { //ゲーム判定
			var i:int = new int;
			var i2:int = new int;
			
			if (flag == -1) { //爆弾 ゲームオーバー
				mode = 5
				for (i = 0; i < sizeX * sizeY; i++) {
					if (pData[i] == -1){
						panels[i].visible = false;
					}
				}
				return;
			}
			
			for (i = 0; i < sizeX * sizeY; i++) { //ゲームクリア判定
				if (pFlag[i] == 1) {
					i2++ //開いているパネル数
				}
			}
			if (sizeX * sizeY - bombNum == i2) { //爆弾以外のパネル数と同じか
				mode = 4;
				for (i = 0; i < sizeX * sizeY; i++) {
					if (pData[i] == -1){
						panels[i].visible = false;
					}
				}
				return;
			}
		}
		
		private function keyDown(e:KeyboardEvent):void {
			
			var i:int = new int;
			
			if (e.keyCode == 82) { //Rキー リセット
				if (mode == 4 || mode == 5){
					setPanel(sizeX, sizeY, bombNum); //パネル作成
					
					for (i = 0; i < sizeX * sizeY; i++) {
						panels[i].visible = true;
						pFlag[i] = 0;
					}
					
					mode = 3;
				}
			}else if (e.keyCode == 77) {
				MASU.visible = true;
				MASU_num.visible = true;
				BOMU.visible = true;
				BOMU_num.visible = true;
				selR1.visible = true;
				selR2.visible = true;
				selL1.visible = true;
				selL2.visible = true;
				number.visible = false;
				for (i = 0; i < sizeX * sizeY; i++ ) {
					panels[i].visible = false;
				}
				
				mode = 0;
			}
		}
		
		private function panelLoad():void {
			
			panels = new Vector.<Bitmap>(5000);
			
			var x:int = new int;//座標
			var y:int = new int;
			var onex:int = new int; //一パネルの横サイズ
			onex = 400 / sizeX;
			var oney:int = new int; //一パネルの縦サイズ
			oney = 300 / sizeY;
			var one:int = new int; //１パネルの大きさ(最終)
			one = (onex > oney) ? oney : onex; //画面に入れるため小さい方を代入
			var index:int = new int; //繰り返し中のパネル位置
			
			for (y = 0; y < sizeY; y++) {
				for (x = 0; x < sizeX; x++) {
					
					index = sizeX * y + x //あらかじめ代入
					
					//画像セット
					panels[index] = new img2;
					panels[index].width = one; //大きさ
					panels[index].height = one; //大きさ
					panels[index].x = x * one + (200 - ((sizeX * one) / 2)); //座標セット
					panels[index].y = y * one;
					stage.addChildAt(panels[index], 1);//表示
					panels[index].visible = true;
				}
			}
		}
		
		private function selR1Click(e:Event):void {
			sizeX++
			sizeY++
		}
		
		private function selR2Click(e:Event):void {
			bombNum++
		}
		
		private function selL1Click(e:Event):void {
			sizeX--
			sizeY--
		}
		
		private function selL2Click(e:Event):void {
			bombNum--
		}
		
	}
	
}