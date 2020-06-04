// author: Alfredo Sánchez Alberca (asalber@ceu.es)
var dni;

function preprocess(){
	echo('require(tennis.elbow)\n');
}

function calculate () {
	dni = getString("dni");
	echo('data(tennis.elbow, package="tennis.elbow")\n');
	echo('set.seed(' + dni + '3)\n');
        echo('tennis.elbow$Age <- tennis.elbow$Age + round(rnorm(length(tennis.elbow$Pain.Relief.Max),0,1))\n');
	echo('tennis.elbow$Pain.Relief.Max <- tennis.elbow$Pain.Relief.Max + round(rnorm(length(tennis.elbow$Pain.Relief.Max),0,0.25))\n');
        echo('tennis.elbow$Pain.Relief.12h <- tennis.elbow$Pain.Relief.12h + round(rnorm(length(tennis.elbow$Pain.Relief.12h),0,0.25))\n');
        echo('tennis.elbow$Pain.Relief.24h <- tennis.elbow$Pain.Relief.24h + round(rnorm(length(tennis.elbow$Pain.Relief.24h),0,0.25))\n');
        echo('tennis.elbow$Pain.Relief.Global <- tennis.elbow$Pain.Relief.Global + round(rnorm(length(tennis.elbow$Pain.Relief.Global),0,0.25))\n');
        echo('bound <- function(x,lowlim,upplim){\n');
        echo('  if (x<lowlim) x<-lowlim\n');
        echo('  if (x>upplim) x<-upplim\n');
        echo('  return(x)\n');
        echo('}\n');
        echo('fun <- function(x) bound(x,1,6)\n');
        echo('tennis.elbow$Pain.Relief.Max <- sapply(tennis.elbow$Pain.Relief.Max,fun)\n');
        echo('tennis.elbow$Pain.Relief.12h <- sapply(tennis.elbow$Pain.Relief.12h,fun)\n');
        echo('tennis.elbow$Pain.Relief.24h <- sapply(tennis.elbow$Pain.Relief.24h,fun)\n');
        echo('tennis.elbow$Pain.Relief.Global <- sapply(tennis.elbow$Pain.Relief.Global,fun)\n');
	echo('.GlobalEnv$tennis.elbow.' + dni + '<- tennis.elbow\n');
	echo('rm(tennis.elbow,envir=.GlobalEnv)\n');
}

function printout () {
	echo('rk.header ("Data generation of Tennis Elbow study", parameters=list("Data set name" = "tennis.elbow.' + dni + '"))\n');
	echo('rk.print("The data set has been created in the Workspace.")\n');
}

