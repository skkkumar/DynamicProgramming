clear
clc

figure(1)
axis square

hold on;


line1 = BresenhamLine.makeLine(0, 0, 100, 0);
plot(line1(:,1),line1(:,2),'b+-','LineWidth',3);


line2 = BresenhamLine.makeLine(0, 0, 0, 100);
plot(line2(:,1),line2(:,2),'r+-','LineWidth',4);

line3 = BresenhamLine.makeLine(0, 0 , -100, 0);
plot(line3(:,1),line3(:,2),'r+-','LineWidth',2);

line4 = BresenhamLine.makeLine(0 , 0 ,0 , -100);
plot(line4(:,1),line4(:,2),'b','LineWidth',4);

line5 = BresenhamLine.makeLine(0, 0, -100, -100);
plot(line5(:,1),line5(:,2),'b','LineWidth',4);

line6 = BresenhamLine.makeLine(0, 0, -100, 100);
plot(line6(:,1),line6(:,2),'g','LineWidth',4);

line7 = BresenhamLine.makeLine(0, 0, 100, -100);
plot(line7(:,1),line7(:,2),'g','LineWidth',4);

line8 = BresenhamLine.makeLine(0, 0, 100, 100);
plot(line8(:,1),line8(:,2),'r','LineWidth',4);


line9 = BresenhamLine.makeLine(0, 0, 80, 100);
plot(line9(:,1),line9(:,2),'r','LineWidth',4);

line10 = BresenhamLine.makeLine(0, 0, 100, 80);
plot(line10(:,1),line10(:,2),'r','LineWidth',4);

line11 = BresenhamLine.makeLine(0, 0, 100, -80);
plot(line11(:,1),line11(:,2),'r','LineWidth',4);

line12 = BresenhamLine.makeLine(0, 0, -100, 80);
plot(line12(:,1),line12(:,2),'r','LineWidth',4);

line13 = BresenhamLine.makeLine(0, 0, -100, -80);
plot(line13(:,1),line13(:,2),'r','LineWidth',4);

line14 = BresenhamLine.makeLine(0, 0, -80, -100);
plot(line14(:,1),line14(:,2),'r','LineWidth',4);

line15 = BresenhamLine.makeLine(0, 0, 80, -100);
plot(line15(:,1),line15(:,2),'r','LineWidth',4);

line16 = BresenhamLine.makeLine(0, 0, -80, 100);
plot(line16(:,1),line16(:,2),'r','LineWidth',4);
