import java.util.Calendar;

PImage source;

float radius = 10;     // 最初の三角の大きさ（外接円の半径）
float addRadius = 5.0; //線と線の間隔（数字が小さいと狭い）
float thickness = 2;  // 線の太さの最小値
float thickMax = 7;   // 線の太さの最大値
PVector[] vertex = {};
PVector[] tPos = {};
PVector center;
float[] tRadius, tAngle;
float ang = 0;

color c1 = color(184, 227, 203); //背景色
color c2 = color(101, 77, 82, 100);  //線の色

void setup() {
  size(800, 800);
  fill(c2); 
  noStroke();

  source = loadImage("image.png"); // 画像をロード
  source.resize(width, height);
  source.loadPixels();

  center = new PVector(width/2, height/2);
  float lastRadius = dist(center.x, center.y, center.x, 30); // 最後の三角の大きさ（外接円の半径）
  float rot = ((lastRadius) / addRadius ) * 120;

  //三角形の頂点を配列に代入
  float lastx = -999;
  for (float ang = 30; ang <= 30+rot; ang += 120) {
    radius += addRadius;
    float rad = radians(ang);
    float x0 =  center.x + (radius*cos(rad));
    float y0 = center.y + (radius* sin(rad));
    if ( lastx > -999) {
      vertex = (PVector[]) append(vertex, new PVector(x0, y0));
    }
    lastx = x0;
  }

  //すべての頂点を配列に代入
  PVector Ac = new PVector();
  int vc = 0;
  while (vc<vertex.length-1) {
    PVector Pos = vertex[vc];
    //Posと次の頂点との距離
    float dist = PVector.dist(vertex[vc], vertex[vc+1]);
    Ac = PVector.sub(vertex[vc+1], vertex[vc]); //次の頂点に向かうベクトルを計算
    Ac.normalize(); //単位ベクトル化

    for (float i = 0; i < dist; i++) {
      Pos.add(Ac.x, Ac.y);
      tPos = (PVector[]) append(tPos, new PVector(Pos.x, Pos.y));
    }
    vc += 1;
  }
  
  //すべての頂点のradius,angleを計算
  tRadius = new float[tPos.length];
  tAngle = new float[tPos.length];
  for(int i = 0; i < tPos.length; i++){
    tAngle[i] = atan2(tPos[i].y - (center.y), tPos[i].x - center.x);
    tRadius[i] = (tPos[i].x - center.x) / cos(tAngle[i]);
  }
  
}

void draw() {
  background(c1); 

  for (int i = 0; i < tPos.length; i++) {
    float tx = center.x + (tRadius[i] * cos(tAngle[i]+ang));
    float ty = center.y + (tRadius[i] * sin(tAngle[i]+ang));
    int cpos = (int(ty) * source.width) + int(tx); // 画像の色を取得
    color c = source.pixels[cpos]; // 暗い色を太い線に、明るい色を細い線にする
    float dim = map(brightness(c), 0, 255, thickMax, thickness);
    ellipse(tx, ty, dim, dim);
  }
  ang += 0.05;
}

void keyPressed() {
  if (key == 's' || key == 'S')saveFrame(timestamp()+"_####.png");
}


String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
