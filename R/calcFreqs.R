# Functions \texttt{calcFreqs}, \texttt{numScore}, \texttt{binScore}, \texttt{binScore}
# and \texttt{plotGene} have been created to respectively count, score or plot points
# on a scatterplot with a 3x3 grid overimposed.

#' calcFreqs
#'
#' \code{calcFreqs} Given two numeric vectors this function overimposes a grid on the scatterplot defined by YMet~Xmet
#' #' and returns a 3X3 matrix of counts with the number of points in each cell of the grid
#' #' for given vertical and horizontal lines.
#'
#' @param xMet First numeric vector which, in principle, contains the methylation values.
#' @param yExp Second numeric vector which, in principle, contains the expression values.
#' @param x1,x2 Coordinates of vertical points in the X axis. Because it is expected to contain methylation values that vary between 0 and 1 the default values are 1/3 and 2/3.
#' @param y1,y2 Coordinates of vertical points in the Y axis. Leaving them as NULL assigns them the percentiles of yVec defined by `percY1` and `percY2`.
#' @param percY1,percY2 Values used to act as default for `y1`and `y2` when these are set to `NULL`
#'
#' @keywords calculation frequencies
#' @export calcFreqs
#'
#' @examples
#' \dontrun{
#' data(trueGenes)
#' xVec<- as.numeric(myMetilData[trueGene1,])
#' yVec<-as.numeric(myExprData[trueGene1,])
#' titolT <- trueGene1
#' plotGeneSel(xMet=xVec, yExp=yVec, titleText=titolT, x1=1/3, x2=2/3)
#' messageTitle(paste("Cell counts for gene",trueGene1))
#' calcFreqs(xMet=xVec, yExp=yVec, x1=1/3, x2=2/3, y1=NULL, y2=NULL, percY1=1/3, percY2=2/3)
#'
#' xVec<- as.numeric(myMetilData[falseGene1,])
#' yVec<-as.numeric(myExprData[falseGene1,])
#' titolF <- falseGene1
#' messageTitle(paste("Cell counts for gene",falseGene1))
#' plotGeneSel(xMet=xVec, yExp=yVec, titleText=titolF, x1=1/3, x2=2/3)
#' calcFreqs(xMet=xVec, yExp=yVec, x1=1/3, x2=2/3, y1=NULL, y2=NULL, percY1=1/3, percY2=2/3)
#' }
#'
calcFreqs <- function (xMet, yExp, x1, x2, y1=NULL, y2=NULL,
                       percY1=1/3, percY2=2/3)
{
  xMet<-as.numeric(xMet)
  yExp<-as.numeric(yExp)
  freqsMat <-matrix(0, nrow=3, ncol=3)
  xVals <- c(x1, x2)
  minExp<-min(yExp); maxExp <- max(yExp); delta<- maxExp-minExp
  if (is.null(y1)) y1<- minExp + percY1*delta
  if (is.null(y2)) y2<- minExp + percY2*delta
  yVals <- c(y1, y2)
  condX <- c("(xMet<=x1)", "((xMet>x1) & (xMet<=x2))", "(xMet>x2)")
  condY <- c("(yExp>y2)", "((yExp<=y2) & (yExp>y1))", "(yExp<=y1)")
  for (i in 1:3){
    for (j in 1:3){
      condij <- paste(condX[j], condY[i], sep="&")
      freqsMat [i,j] <- sum(eval(parse(text=condij)))
    }
  }
  return(freqsMat)
}

