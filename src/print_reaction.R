#' Print a reaction with additional options
#'
#' @description An extension of sybil's function \code{printReaction}.
#'
#' @param mod Model of class `modelorg`
#' @param react Vector of reaction IDs.
#' @param use.ids Boolean. Indicating whether metabolite IDs should be printed
#' instead of metabolite names.
#'
#' @return Vector of type `character` with the individual reaction equations.
#'
#' @export
print_reaction <- function(mod, react, use.ids = FALSE) {
  check <- checkReactId(mod, react = react)
  if (is(check, "reactId")) {
    cind <- react_pos(check)
  }
  else {
    stop("check argument react")
  }
  
  mat <- mod@S[, cind, drop = FALSE]
  nnz <- apply(mat, 2, "!=", 0)
  reaction <- character(length(cind))
  
  for (j in seq(along = cind)) {
    
    if(use.ids) {
      met <- met_id(mod)[nnz[, j]]
    } else {
      met <- met_name(mod)[nnz[, j]]
    }
    
    nzv <- mat[, j][nnz[, j]]
    
    ed <- nzv < 0
    pd <- nzv > 0
    
    if (sum(ed) > 0) {
      educt   <- paste(paste("(", abs(nzv[ed]), ")", sep = ""),
                       met[ed], collapse = " + ")
    }
    else {
      educt = ""
    }
    
    if (sum(pd) > 0) {
      product <- paste(paste("(", nzv[pd], ")", sep = ""),
                       met[pd], collapse = " + ")
    }
    else {
      product = ""
    }
    
    arrow <- " <==> "
    if(mod@lowbnd[cind[j]] >= 0 & mod@uppbnd[cind[j]] > 0)
      arrow <- " --> "
    if(mod@lowbnd[cind[j]] < 0 & mod@uppbnd[cind[j]] <= 0)
      arrow <- " <-- "
    
    reaction[j] <- paste(educt, product, sep = arrow)
  }
  
  names(reaction) <- react
  
  return(reaction)
}