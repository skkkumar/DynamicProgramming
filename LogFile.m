%-- 05/12/2012 23:38 --%
clear
% runs simple 2d detection against inverted tongue image
ContourDetection2('resources/images/tongue-inverted.png','resources/init1.ctr','resources/init2.ctr',101,0.5)

%runs 3d detection against inverted tongue image
ContourDetection3('resources/images/tongue-inverted.png','resources/init1.ctr','resources/init2.ctr',101,0.5)

% produces m versus t graph
MversusTGraph('resources/images/tongue-inverted.png','resources/init1.ctr','resources/init2.ctr',1, 101,0.5);

% produces badly detected contour when contours are not oriented properly
ContourDetection3('resources/images/tongue-inverted.png','resources/init11.ctr','resources/init12.ctr',101,0.5)

% produces contour for lena image  
ContourDetection3('resources/images/lena-gray.png','resources/init1.ctr','resources/init2.ctr',101,0.3)

% produces contour for baboon image
ContourDetection3('resources/images/baboon-grayscale.png','resources/init1.ctr','resources/init2.ctr',101,0.3)

% produces closed contour for girl's face
ClosedContourDetection3('resources/images/Girl-with-Book-Grayscale.jpg','resources/init10.ctr','resources/init9.ctr',60,0.3);
