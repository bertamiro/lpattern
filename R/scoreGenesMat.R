#' scoreGenesMat
#'
#' \code{scoreGenesMat} scores scatterplots using a binary and a numeric schemes on a row-wise basis.
#'
#' @param mets Matrix of methylation values
#' @param expres Matrix of expression values
#' @param aReqPercentsMat Matrix of minimum maximum percentage of counts to have in a given cell
#' @param aWeightMifL A matrix of weights to score the previous counts if the scatterplot has been classified as L.
#' @param aWeightMifNonL A matrix of weights to score the previous counts if the scatterplot has been classified as non-L
#' @param x1,x2 Coordinates of vertical points in the X axis. Because it is expected to contain methylation values that vary between 0 and 1 the default values are 1/3 and 2/3.
#' @param y1,y2 Coordinates of vertical points in the Y axis. Leaving them as NULL assigns them the percentiles of yVec defined by `percY1` and `percY2`.
#' @param percY1,percY2 Values used to act as default for `y1`and `y2` when these are set to `NULL`
#' @param trace logical. Set to TRUE to print count matrices as they are computed
#'
#' @export scoreGenesMat
#' @examples
#' \dontrun{
#' sampleSize <- dim(mets)[2]
#' numGenes <-   dim(mets)[1]
#'reqPercentages <- matrix (c(2, 20, 5, 1, 40, 20, 0, 1, 2), nrow=3, byrow=TRUE)
#'(theWeightMifL=matrix (c(2,-2,-sampleSize/5,1,0,-2,1,1,2), nrow=3, byrow=TRUE))
#'(theWeightMifNonL=matrix (c(0,-2,-sampleSize/5,0,0,-2,0,0,0), nrow=3, byrow=TRUE))
#'scoreGenesMat <- function(mets, expres,
#'                          x1=1/3, x2=2/3,
#'                          y1=NULL, y2=NULL, percY1=1/3, percY2=2/3,
#'                          aReqPercentsMat = reqPercentages,
#'                          aWeightMifL= theWeightMifL,
#'                          aWeightMifNonL= theWeightMifNonL) # , trace=FALSE)}


scoreGenesMat <- function(mets, expres,
                          x1=1/3, x2=2/3,
                          y1=NULL, y2=NULL, percY1=1/3, percY2=2/3,
                          aReqPercentsMat, # =standardPercentsMat,
                          aWeightMifL, # =standardWeightM,
                          aWeightMifNonL) # , trace=FALSE)
{
  N <- dim(mets)[2]
  Ngenes <-nrow(mets)
  scores <- data.frame(logicSc=rep(FALSE, Ngenes), numericSc=rep(0,Ngenes))
  rownames(scores)<- rownames(mets)
  minmaxCounts <- toReqMat (N, aReqPercentMat=aReqPercentsMat)
  for (gene in 1:Ngenes){
    theGene <- rownames(expres)[gene]
    xVec<- mets[theGene,]
    yVec<- expres[theGene,]
    geneGrid <- calcFreqs(xMet=xVec, yExp=yVec, x1=x1, x2=x2,
                          y1=y1, y2=y2, percY1=percY1, percY2=percY2)
    # TRACE
    # if (trace) show(geneGrid)
    # TRACE
    binSc <-  binScore (geneGrid, minmaxCounts)
    scores[gene, "logicSc"] <- binSc
    numSc <- numScore (geneGrid, LShaped=binSc,
                       aWeightMifL=aWeightMifL,
                       aWeightMifNonL=aWeightMifNonL )
    scores[gene, "numericSc"] <- numSc
  }
  return (scores)
}


toReqMat <- function (numPoints, aReqPercentMat){
  return(round(aReqPercentMat*numPoints/100,0)) #  return(round(aReqPercentMat*sum(numPoints)/100,0))
}
