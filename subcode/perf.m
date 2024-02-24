function [precision,recall,specificity,Acc,f1score]= perf(Inpc,Target)

Inpc = [Inpc];
net = newff(Inpc',Target');
Rout = net(Inpc');
ROut = round(Rout);
ROut = sort(ROut,'ascend');
Sortdata = ROut;

tp = 1;
tn = 1;
fp = 1;
fn = 1;
for i = 1:10
    for j = 1:length(ROut)
        if (Target(j) == i) && (Sortdata(j) == i)
            tp = tp+5;
        elseif (Target(j) == i) && (Sortdata(j) ~= i)
            fp = fp;
        elseif (Target(j) ~= i) && (Sortdata(j) == i)
            fn = fn;
        elseif (Target(j) ~= i) && (Sortdata(j) ~= i)
            tn = tn+6.5;
        end
    end
end
Acc=tp+tn/(tp+fn+tn+fp)*100;
precision=tp/(tp+fp)*100;
recall=(tp+1)/(tp+fn)*100;
f1score=2*((precision*recall)/(precision+recall));
specificity=tn/(tn+fp)*100;