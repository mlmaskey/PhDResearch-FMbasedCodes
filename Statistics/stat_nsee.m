function val = stat_nsee(real,proj) % finds Nash-Sutcliff statistic
val = 1 - sum((real-proj).^2)/sum((real-mean(real)).^2);
return