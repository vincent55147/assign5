PImage enemy,fighter,treasure,shoot;
PImage[] flame=new PImage[5];
//background
PImage bg1,bg2,hp,bg3,start1,start2,end1,end2;
PFont fh;
int  treasureX,treasureY,bg1x=0;
float  hphave;
int  fighterX,fighterY,i,enemysize=61,fightersize=51;
int  mode,s,ego=0,enemylose,shoothave=0,shootnum=0,f=5,bownX,bownY,score;
int  enemyCount=8;

int []enemytag=new int [5];
int []enemyX=new int [enemyCount];
int []enemyY=new int [enemyCount];
int []shootX=new int [5];
int []shootY=new int [5];

boolean []enemytagtrue=new boolean [5];
boolean []enemyhave=new boolean [8];
boolean []shootleave=new boolean [5];
boolean  go_left=false;
boolean  go_up=false;
boolean  go_down=false;
boolean  go_right=false;
boolean  start=true;
boolean  end=false;
boolean  bown=false;
boolean  change,shootgo,check;
void  setup(){
size(640,480);
fh=createFont("Arial",24);
fighterX=width-fightersize;
fighterY=height/2;
//loadimage
bg1=loadImage("img/bg1.png");
bg3=loadImage("img/bg1.png");
bg2=loadImage("img/bg2.png");
fighter=loadImage("img/fighter.png");
treasure=loadImage("img/treasure.png");
hp=loadImage("img/hp.png");
enemy=loadImage("img/enemy.png");
start1=loadImage("img/start1.png");
start2=loadImage("img/start2.png");
end1=loadImage("img/end1.png");
end2=loadImage("img/end2.png");
for(int  a=0;a<5;a++)
flame[a]=loadImage("img/flame"+(a+1)+".png");
shoot=loadImage("img/shoot.png");
startthing();
}
void  draw()
{
if(start){
image(start2,0,0);
if((mouseX>206&&mouseX<446)&&(mouseY>306&&mouseY<408))
image(start1,0,0);
}else if(end){
image(end2,0,0);
if((mouseX>206&&mouseX<446)&&(mouseY>306&&mouseY<408))
image(end1,0,0);
}
//game
else{
bg1x+=2;
bg1x=bg1x%1280;
image(bg1,bg1x,0);
image(bg2,bg1x-640,0);
image(bg3,bg1x-1280,0);
ego=ego+5;
//enemy
if(mode%3+1==1)
enemymode(5,5,305,419,0);
if(mode%3+1==2)
enemymode(5,8,31,175,0);
if(mode%3+1==3)
enemymode(8,5,0,419,4);
//fighter,treasure
image(fighter,fighterX,fighterY);
fill(255,0,0);
rect(10,0,hphave,31);
image(hp,0,0);
image(treasure,treasureX,treasureY);
if((fighterX<=width-fightersize&&fighterX>=0))
if((fighterY<=height-fightersize&&fighterY>=0)){
if(go_up)
if(fighterY>5)
fighterY-=5;
else
fighterY=0;

if(go_down)
if(fighterY<height-fightersize-5)
fighterY+=5;
else
fighterY=height-fightersize;
if(go_left)
if(fighterX>5)
fighterX-=5;
else
fighterX=0;
if(go_right)
if(fighterX<width-fightersize-5)
fighterX+=5;
else
fighterX=width-fightersize;
}

//shoot
for(int  ea=0;ea<5;ea++){
if(shootleave[ea]){
image(shoot,shootX[ea],shootY[ea]);
if(shootX[ea]>=-31){
shootX[ea]-=3;
enemytag[ea]=closeenemy(enemyX,enemyY,shootX[ea],shootY[ea],fighterX);
if(enemytag[ea]!=-1)
shootY[ea]+=(enemyY[enemytag[ea]]-shootY[ea])/100;
}
else{
shootleave[ea]=false;
shoothave--;
}
}
}

//shootcatchenemy
for(int  p=0;p<5;p++){
for(int  r=0;r<8;r++){
if(shootleave[p]==true&&enemyhave[r]==true){
check=ishit(enemyX[r],enemyY[r],enemysize,enemysize,shootX[p],shootY[p],31,27);
if(check==true){
shoothave--;
bown_f(r);
shootleave[p]=false;
}
}
scoreChange(check);
check=false;
}
}

//fightercatchenemy
for(int  p=0;p<8;p++){
if(enemyhave[p]==true){
check=ishit(fighterX,fighterY,fightersize,fightersize,enemyX[p],enemyY[p],enemysize,enemysize);
if(check==true){
hphave-=195*20/100;
bown_f(p);
}
}
check=false;
}


if(frameCount%(60/10)==0){
if(f<5){
f++;
}
}
if(f<5)
image(flame[f],bownX,bownY);

//catchtreasure
check=ishit(fighterX,fighterY,fightersize,fightersize,
treasureX,treasureY,41,41);
if(check==true){
if(hphave<195)
hphave+=195*10/100;
if(hphave>195)
hphave=195;
treasureY=floor(random(41,439));
treasureX=floor(random(41,599));
check=false;
}
if(hphave<=0){
end=true;
mode=0;
ego=0;
}
}
}
//0-straight,1-slope,2-dimond
void addEnemy(int  type)
{
for(int i=0;i<enemyCount;++i){
enemyX[i]=-1;
enemyY[i]=-1;
}
switch(type){
case 0:
addStraightEnemy();
break;
case 1:
addSlopeEnemy();
break;
case 2:
addDiamondEnemy();
break;
}
}

void addStraightEnemy()
{
float t=random(height-enemy.height);
int h=int (t);
for(int i=0;i<5;++i){

enemyX[i]=(i+1)*-80;
enemyY[i]=h;
}
}
void addSlopeEnemy()
{
float t=random(height-enemy.height*5);
int h=int (t);
for(int i=0;i<5;++i){

enemyX[i]=(i+1)*-80;
enemyY[i]=h+i*40;
}
}
void addDiamondEnemy()
{
float t=random(enemy.height*3,height-enemy.height*3);
int h=int (t);
int x_axis=1;
for(int i=0;i<8;++i){
if(i==0||i==7){
enemyX[i]=x_axis*-80;
enemyY[i]=h;
x_axis++;
}else if(i==1||i==5){
enemyX[i]=x_axis*-80;
enemyY[i]=h+1*40;
enemyX[i+1]=x_axis*-80;
enemyY[i+1]=h-1*40;
i++;
x_axis++;
}else{
enemyX[i]=x_axis*-80;
enemyY[i]=h+2*40;
enemyX[i+1]=x_axis*-80;
enemyY[i+1]=h-2*40;
i++;
x_axis++;
}
}
}

boolean ishit(int  bX,int  bY,int  bW,int  bH,int  aX,int  aY,int  aW,int  aH){
if((aX+aW>=bX&&aX<=bX+bW)&&(aY+aH>=bY&&aY<=bY+bH))
return(true);
else
return(false);
}
int closeenemy(int []enemyX,int []enemyY,int  shootX,int  shootY,int  fighterX){
float  checkline;
int enemynum=-1;
float closeline=9999;
for(int l=0;l<8;l++){
if(enemyX[l]<+640-fightersize&&enemyX[l]>=0&&enemyX[l]<fighterX){
checkline=sqrt(abs((enemyX[l]-shootX)+(enemyY[l]-shootY)));
if(checkline<closeline){
closeline=checkline;
enemynum=l;
}
}
}
return(enemynum);
}
void  enemymode(int  a,int  b,int  c,int  d,int  e){
for(int i=0;i<enemyCount;++i){
if(enemyhave[i]==true)
if(enemyX[i]!=-1||enemyY[i]!=-1){
image(enemy,enemyX[i],enemyY[i]);
enemyX[i]+=5;
}
}
for(int v=0;v<a;v++){
if(enemyhave[v]==false)
enemylose++;
}
if(enemylose==a||ego>=1040){
enemyclean(b,c,d,e);
}
enemylose=0;
}
void startthing(){
hphave=195*20/100;
fighterX=width-fightersize;
fighterY=height/2;
treasureY=floor(random(41,439));
treasureX=floor(random(41,599));
enemyY[4]=floor(random(0,419));
for(int open=0;open<5;open++){
shootleave[open]=false;
enemyhave[open]=true;
}
shoothave=0;
f=5;
mode=0;
addEnemy(mode);
ego=score=0;
}

void enemyclean(int  x,int  r1,int  r2,int  num){
for(int open=0;open<x;open++)
enemyhave[open]=true;
enemyY[num]=floor(random(r1,r2));
mode++;
mode=mode%3;
addEnemy(mode);
ego=0;
}
void scoreChange(boolean  scorechange)
{
if(scorechange)
score+=20;
textFont(createFont("fh",20));
text("Score:"+score,0,460);
}

void  bown_f(int  r){
enemyhave[r]=false;
f=0;
bownX=enemyX[r];
bownY=enemyY[r];
}

void mousePressed(){
if(start){
if((mouseX>206&&mouseX<446)&&(mouseY>306&&mouseY<408))
start=false;
}
if(end){
if((mouseX>206&&mouseX<446)&&(mouseY>306&&mouseY<408))
end=false;
startthing();
}
}

void keyPressed(){
switch(keyCode){
case UP:
go_up=true;
break;
case DOWN:
go_down=true;
break;
case LEFT:
go_left=true;
break;
case RIGHT:
go_right=true;
break;
case 32:
if(shoothave<5){
shootnum++;
shoothave++;
shootleave[shootnum%5]=true;
shootX[shootnum%5]=fighterX-31;
shootY[shootnum%5]=fighterY+fightersize/4;

break;
}
}
}

void keyReleased(){
switch(keyCode){
case UP:
go_up=false;
break;
case DOWN:
go_down=false;
break;
case LEFT:
go_left=false;
break;
case RIGHT:
go_right=false;
break;
}
}
