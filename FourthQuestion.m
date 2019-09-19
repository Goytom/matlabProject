function FourthQuestion()

    [ruralZipw, nonRuralZipw] =  readZipcodes('zipFile.txt', 10); 
    nearestRurawl = nearestRural('zipFile.txt',10);
    [filedata, ~, ~, ~] = balancePopulation(nonRuralZipw, ruralZipw, nearestRurawl, 150, 10, 50);
    for qq = 1:size(filedata,1)
        disp(['Zipcode ' num2str(filedata(qq,1)) ' will shift ' num2str(round(filedata(qq,4))) ' people to zipcode ' num2str(filedata(qq,2)) ' which is a distance of ' num2str(filedata(qq,3)) ' away. ']) ; 
    end
    fprintf("\n");
    fprintf("And the Optimal Thresh is: %f\n", zipcodeBalancer('zipFile.txt', 10, [12, 34, 45, 109, 120, 10], 10))

    function Z = MakeZipcode(zip, pop, area, dens, lat, long)
    Z = struct('zip',zip, 'population',pop, 'area',area, 'density',dens, 'latitude',lat, 'longitude',long);
    end

    function [ruralZip, nonRuralZip] = readZipcodes(zipFile, rThresh)
%     filename2 = zipFile;
%     delimiterIn = ' ';
%     headerlinesIn = 1;
%     A = importdata(filename2,delimiterIn,headerlinesIn);
%     %display(A.colheaders);
%     %display(A.data);
    A = dlmread(zipFile);
    rcnt = 0;
    k = size(A,1);
    for n = 1:k
        if A(n,4) <= rThresh
            rcnt = rcnt + 1;
        end
    end
    if rcnt == 0
        error('Struct array Z does not exist.'); %%?????
    end
    Ncnt = k - rcnt;
    rM = zeros(rcnt,6);
    urM = zeros(Ncnt,6);
    nn = 1;
    mm = 1;
    for j = 1:k
        if A(j,4) <= rThresh
            rM(nn,:) = A(j,:);
            nn = nn + 1;
        else
            urM(mm,:) = A(j,:);
            mm = mm + 1;
        end
    end
    ruralZip = (MakeZipcode(num2cell(rM(:,1)),num2cell(rM(:,2)),num2cell(rM(:,3)),num2cell(rM(:,4)),num2cell(rM(:,5)),num2cell(rM(:,6))))';
    nonRuralZip = (MakeZipcode(num2cell(urM(:,1)),num2cell(urM(:,2)),num2cell(urM(:,3)),num2cell(urM(:,4)),num2cell(urM(:,5)),num2cell(urM(:,6))))';
    end
    %[f g] = readZipcodes('zipFile.txt',10)
    function nRural = nearestRural(zipFile,rThresh)
        [R,N] = readZipcodes(zipFile,rThresh);
        mi = size(R,2);  
        mj = size(N,2); 
        distance = zeros(mj,mi);
        for m = 1:mj
            for n = 1:mi
            distance(m,n) = sqrt((N(m).latitude - R(n).latitude)^2 + (N(m).longitude - R(n).longitude)^2);
            end
            
        end
        nRural = zeros(mj,2);
        for kk = 1:mj
            [nRural(kk,2), nRural(kk,1)] = min(distance(kk,:));
        end
    end
   % nearestRural('zipFile.txt',10)
   % numSuperUrban, numRural, numSupBfr, 
    function [fD, numSuperUrban, numRural, numSupBfr] = balancePopulation(nonRuralZip, ruralZip, nearestRural, suThreshValue, rThresh, p);
        %[ruralZip, nonRuralZip] =  readZipcodes(zipfile, 10);
        nr = size(nonRuralZip,2);
        r = size(ruralZip,2);
        numSupBfr = 0;   %%%%%?*    
        for g = 1:nr
            if nonRuralZip(g).density >= suThreshValue
                numSupBfr = numSupBfr + 1;
            end
        end
        kh = 1; %count for filedata matrix
        fD = zeros(numSupBfr,4);
        for gg = 1:nr
            if nonRuralZip(gg).density >= suThreshValue
                jk = double(nearestRural(gg,1));
                fD(kh,1) = nonRuralZip(gg).zip;
                fD(kh,2) = ruralZip(jk).zip;
                fD(kh,3) = nearestRural(gg,2);
                fD(kh,4) = (p/100)*(nonRuralZip(gg).population);
                kh = kh + 1;
                ruralZip(jk).population = ruralZip(jk).population + (p/100)*(nonRuralZip(gg).population);
                ruralZip(jk).density = (ruralZip(jk).population)/(ruralZip(jk).area);
                nonRuralZip(gg).population = nonRuralZip(gg).population*(1 - (p/100)); 
                nonRuralZip(gg).density = nonRuralZip(gg).population/nonRuralZip(gg).area;
            end
                
        end     
        
        
        numRural = 0;
        numSuperUrban = 0;
        for rw = 1:r
            if ruralZip(rw).density <= rThresh
                numRural = numRural + 1;
            end
            if ruralZip(rw).density >= suThreshValue
                numSuperUrban = numSuperUrban + 1;
            end
        end
        for nw = 1:nr
            if nonRuralZip(nw).density <= rThresh
                numRural = numRural + 1;
            end
            if nonRuralZip(nw).density >= suThreshValue
                numSuperUrban = numSuperUrban + 1;
            end
        end
    end  
%     [ruralZipw, nonRuralZipw] =  readZipcodes('zipFile.txt', 10);
%     nearestRurawl = nearestRural('zipFile.txt',10);
%     [gf, rr, er, ew] = balancePopulation(nonRuralZipw, ruralZipw, nearestRurawl, 10, 15, 1);
%     gf
    function optimalThresh = zipcodeBalancer(zipFile, rThresh, suThresh, p)
       [ruralZip, nonRuralZip] =  readZipcodes(zipFile, rThresh);
       nearestRuralx = nearestRural(zipFile,rThresh);
       sz = size(suThresh,2);
       opThrM = zeros(1,sz);
       y1 = size(ruralZip,2);
       %x1 = size(nonRuralZip,2);
       for nk = 1:sz
           suThreshValue = suThresh(nk);
           [~, x, y, z] = balancePopulation(nonRuralZip, ruralZip, nearestRuralx, suThreshValue, rThresh, p);
           opThrM(nk) =   (x/z) - (y/y1) ;
       end
       [~, indx]  = max(opThrM);
       optimalThresh = suThresh(indx);  
    end
end




