% Scirpt to create coupled oscillators simulation 
% Visual representation
% Author tarunkhajuria42@gmail.com
% Year 2012

clear
%Taking input for number of boxes 
n = input('enter number of boxes \n');
%Inputs for spring constants.
k = input('enter value of the spring constants in N/m \n');
 for g = 2:n+1
    k = [k;input('enter value of the spring constants in N/m \n')];
 end
 %Inputs for mass of objects.
 m = input('Enter the mass of objects in Kg \n');
 for g = 2:n
    m = [m;input('Enter the mass of objects in Kg \n')];
 end
 %Input for inital displacements.
 C = input('enter the initial displacement with direction of the n blocks \n');
 for g = 2:n
    C = [C;input('enter the initial displacement with direction of the n blocks \n')];
 end
 %Input for damping constants. 
 d = input('enter value of dmaping constant \n');
 %Input for time of movie.
 tm=input('enter time for the movie');
 %Creating the co-efficient matrix for differntial equations.
 for r = 1:2*n
     if (r<=n)
        for c = 1:2*n
            if (c == n+r)
                X(r,c) = 1;
            else
                X(r,c) = 0;
            end
        end
     else
         for c = 1:2*n
             if (c == (r-n-1))
                 X(r,c) = (k(r-n)/m(r-n));
             elseif (c == r-n)
                 X(r,c) = ((-k(r-n)-k(r-n+1))/m(r-n));
             elseif (r==c)
                     X(r,c)= -d/m(r-n);
             elseif (c == r-n+1)
                 if((r-n)==n)
                    X(r,c)=0;
                 else
                    X(r,c) = (k(r-n+1)/m(r-n));
                 end
               else 
                 X(r,c) = 0;
             end
         end
     end
 end
 %Finding eigen ector and eigen values respectively.
 [V,D] = eig(X);

 for g = 1:n
     C = [C ; 0];
 end
 %Counter for time and movie frame starts
 t=0;
     for ctt=0:tm*25
 %Calculating the displacement of each block at time t.
     Y = V(:,1).*(exp(D(1,1)*t));
        for g=2:2*n
            Y = [Y,V(:,g).*(exp(D(g,g)*t))];
        end
        Y = [Y,C];
    if(t==0)
         Z = rref(Y);
    end
    W=Y(:,1).*Z(1,(2*n)+1);
    for g=2:2*n
        W = [W,(Y(:,g).*Z(g,(2*n)+1))];
    end
    for q = 1:2*n
        sm(q)=0;
        for r = 1:2*n
            sm(q) = sm(q)+ W(q,r);
        end
    end
 %Collecting data for final graph plots
    if(t==0)
        tim=0;
        dat=(sm');
    else
        tim=[tim,t];
        dat=[dat,(sm')];
    end
 %Creating background
    A = [170;-30;-30;170];
    B = [100;100;-100;-100];
    fill(A,B,'w')
   hold on;
 %Creating the boxes.  
   for j = 0:n-1
        h=33*j;
        K = [5+h+sm(j+1);-5+h+sm(j+1);-5+h+sm(j+1);5+h+sm(j+1)];
        L = [4;4;-4;-4];
        fill(K,L,'r')
    end
 %Drawing the surface
    x1=[-30;170];
    y1=[-4;-4];
    plot(x1,y1)
 %Making first holding clamp  
    sh1=[-28,-28,-28.5,-28.5];
    sh2=[-4,4,4,-4];
    fill(sh1,sh2,'b');
 %Making the connecting wires
 for i=0:n    
      hd=33*i;
         if(i==0)
            lx1 = [-28+hd;-24+hd];
         else
            lx1 = [-28+hd+sm(i);-24+hd+sm(i)];
         end
      ly1 = [0;0];
         if(i==n)
             lx2 = [-8+hd;-5+hd];
         else    
             lx2 = [-8+hd+sm(i+1);-5+hd+sm(i+1)];
         end
      ly2 = [0;0];
      plot(lx1,ly1);
      plot(lx2,ly2);
      xs1 = lx1(2);
      ys1 = 0;
      in=lx2(1)-lx1(2);
      in=in/16;
      xco=lx1(2);
%Making the spring.
      for k = 1:16
        xco=xco+in; 
            if(mod(k,2)==0)
                xs1=[xs1;xco];
                ys1=[ys1;0];
            else
                xs1=[xs1;xco];
                 ys1=[ys1;2];
            end
    end
 
    plot(xs1,ys1)
 end
%Making the other holding clamp.
 sh1=[lx2(2),lx2(2),lx2(2)+0.5,lx2(2)+0.5];
 sh2=[-4,4,4,-4];
 fill(sh1,sh2,'b');
 hold off;
 t=t+0.04;
%Capturing each frame.
 mvi(ctt+1)=getframe;
     end
%Playing the movie with the vector of frames     
%movie(mvi,1,25)
%Plotting the graph for simulation
plot(tim,dat(1,:));
legend('Object 1');
xlabel('Time');
ylabel('Displacement');
title('Displacement vs time graph');
clc

 
 