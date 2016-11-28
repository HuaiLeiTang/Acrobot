function [norma, var] = cont_hinf_norm(A,B,C,D,E)

    n = size(A,1); % Numero de estados
    m = size(B,2);
    
    setlmis([]); % Preparar ambiente para equa��o matricial

    mi = lmivar(1,[1 0]); %norma mi
    X = lmivar(1,[n 1]); %variavel X
    Z = lmivar(2,[m n]); %variavel Z
    
    %gamma = lmivar(1,[1 0]);
    %P = lmivar(1,[n 1]);
    
    lmiterm([-1 1 1 X],1,1); %X>0
    
    lmiterm([2 1 1 X],A,1,'s'); %AX + XA' (termo 1 1 da matriz)
    %matriz (sinal invertido da desigualdade)
    %posicao na matriz
    %variavel
    %multiplica pela esquerda
    %multiplica pela direita
    %simetrico
    
    lmiterm([2 1 1 Z],B,1,'s'); %BZ + ZB'
    lmiterm([2 2 1 0],E'); %E'
    lmiterm([2 2 2 mi],-1,1); %-mi
    lmiterm([2 3 1 X],C,1); %CX
    lmiterm([2 3 1 Z],D,1); %DZ
    lmiterm([2 3 3 0],-1); %-I
    
    lmisys = getlmis; %montar equa��o
    options = [1e-7,2000,0,200,1]; %opcoes de calculo
    
    c = zeros(decnbr(lmisys),1);
    %array com todos elementos zero.
    %Numero de elementos = numero de vari�veis de decisao do sistema
    c( decinfo(lmisys,mi) ) = 1;

    [copt,xopt] = mincx(lmisys,c,options);
    
    if ~isempty(xopt) %se encontrou valor otimo
        var.X = dec2mat(lmisys,xopt,X);
        var.Z = dec2mat(lmisys,xopt,Z);
        var.K = var.Z/var.X; %ganho do controlador
        var.mi = dec2mat(lmisys,xopt,mi);
        norma = sqrt(copt);
    else
        var.X = [];
        var.Z = [];
        var.K = [];
        norma = inf;
    end

end