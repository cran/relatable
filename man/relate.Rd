% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/relate.R, R/relation.R
\name{relate}
\alias{relate}
\alias{relation}
\title{Map inputs from a vector of keys to a vector of values.}
\usage{
relate(X, A, B, default = NA, atomic = TRUE, named = FALSE,
  allow_default = TRUE, heterogeneous_outputs = FALSE,
  handle_duplicate_mappings = FALSE, report_properties = FALSE,
  relation_type = "func", restrictions = list(),
  map_error_response = "warn")

relation(A, B, default = NA, atomic = TRUE, named = FALSE,
  allow_default = TRUE, heterogeneous_outputs = FALSE,
  handle_duplicate_mappings = FALSE, report_properties = FALSE,
  relation_type = "func", restrictions = list(),
  map_error_response = "warn")
}
\arguments{
\item{X}{A vector of inputs}

\item{A}{A vector possible inputs ordered to correspond to desired outputs given by \code{B}.}

\item{B}{A vector possible outputs ordered to correspond to each input to the relation given by \code{A}.}

\item{default}{The default value to return if the value of \eqn{F(x)} is undefined.}

\item{atomic}{If \code{TRUE}, the return vector \eqn{Y} will be atomic; If \code{TRUE} \eqn{Y} will be a list vector. To allow for multiple outputs from a single input, \code{atomic} must be set to \code{FALSE} if \code{relation_type = "many_to_many"} or \code{"one_to_many"}, or if \code{relation_type = NULL} and \code{max_one_y_per_x = FALSE} is an element of \code{restrictions} list.}

\item{named}{The elements of the returned vector \eqn{Y} will be named by to their corresponding inputs in X.}

\item{allow_default}{If TRUE, the provided default will be returned when \eqn{F(x)} is undefined; otherwise invalid mappings will return an error determined by the \code{map_error_response} argument.}

\item{heterogeneous_outputs}{By default, elements \eqn{y} of the output vector \eqn{Y} will be returned as atomic vectors. In many-to-many and one-to-many relations, if the elements in the codomain are not all of the same type, this will coerce outputs to the same type. Set \code{heterogeneous_outputs = TRUE} to return each \eqn{y} as a list vector. This will avoid coercion of individual outputs to the same type, but may also result in messy nested list vectors.}

\item{handle_duplicate_mappings}{If \code{TRUE}, each possible input/output pair in the returned function \eqn{F} for duplicate mappings and removes them. This may increase the runtime for larger mappings, but only for the first instance of \code{relation}. The function returned by \code{relation} does not need to re-check these properties, so will run more quickly. If \code{handle_duplicate_mappings = FALSE}, duplicate mappings from \code{A} to \code{B} in \code{relate} or \code{relation} will return multiple instances of the same output. See Examples.}

\item{report_properties}{If \code{TRUE}, \code{relation} reports which restrictions \eqn{F} conforms to. See Details.}

\item{relation_type}{Ensure that the relation is restricted to a certain type, e.g. "bijection". See Details.}

\item{restrictions}{A named list of logicals imposing constraints on the relation. These will only be used if relation_type is \emph{NULL}. See Details.}

\item{map_error_response}{How to deal with mapping errors caused by violated restrictions. Takes values "ignore", "warn", or "throw".}
}
\description{
\code{relate} returns a vector \eqn{Y = F(X)} where \eqn{F} maps each element of input vector \code{X} from its position in vector \code{A} to its corresponding position in vector \eqn{B}. Can be applied as a vectorised key-value dictionary with an optional default return value. Additional options restrict mapping types so relation \eqn{F} must be a function, injective, surjective, etc.

\code{relation} returns a reusable function \eqn{F} that performs the same operation as \code{relate}. In addition to providing a reusable function, if \code{handle_duplicate_mappings = TRUE}, \code{relation} checks for and eliminates duplicate mappings that would be invalid inputs for \code{relate}. If \code{report_properties = TRUE}, \code{relation} also prints the restrictions the mapping from \code{A} to \code{B} conforms to.
}
\details{
\code{relate} returns vector of outputs \eqn{Y = F(X)} where the \eqn{F} is a relation defined by the collection of ordered pairs \eqn{(a_i, b_i)} where \eqn{a_i, b_i} are the \eqn{i}th elements of \code{A} and \code{B} respectively. If \eqn{F(x)} is undefined because \eqn{x} is not in \eqn{A} or it does not map to an element of \code{B}, \code{relate} will either return \code{default} if \code{allow_default = TRUE}.  Otherwise the function will throw an error.

The relation \eqn{F} can be restricted so it conforms to a particular type specified, for example \code{relation_type = "one_to_many"}. If \code{relation_type = NULL}, the properties are determined by restrictions specified with a named list, for example \code{restrictions = list(min_one_y_per_x = TRUE)}. For all relations where \code{min_one_y_per_x = FALSE}, only a list vector can be returned, so an error will be thrown if \code{atomic = TRUE}. If \code{A} and \code{B} do not produce a relation that conforms to the specified type or restrictions, the value of \code{map_error_response} will determine whether the \code{relate} ignores the error, reports it, or throws it. The full list of restrictions and relation types are listed below:

\strong{Restrictions}

\emph{NB:} 1) The \code{restrictions} argument is only used if \code{relation_type = NULL}; 2) If relation is allowed to return multiple values, i.e. \code{max_one_y_per_x = FALSE}, then \code{atomic} must be set to \code{FALSE}, otherwise an error will be throw; 3). All unspecified restrictions are assumed false, e.g.
\code{restrictions = list()} is equivalent to
\code{restrictions = list("min_one_y_per_x" = FALSE,
"min_one_x_per_y" = FALSE,
"max_one_y_per_x" = FALSE,
"max_one_x_per_y" = FALSE)}
\describe{
  \item{\code{min_one_y_per_x}}{Guarantees at least one \eqn{y = F(x)} in \code{B} exists for each \eqn{x} in \code{A}. Returns an error if B is longer than A.}
  \item{\code{min_one_x_per_y}}{Guarantees at least one \eqn{x} in \code{A} exists for each \eqn{y} in \code{B} such that \eqn{y = F(x)}. Returns an error if A is longer than B.}
  \item{\code{max_one_y_per_x}}{Guarantees no more than one \eqn{y = F(x)} in \code{B} exists for each \eqn{x} in \code{A}. Returns an error if A contains duplicate elements.}
  \item{\code{max_one_x_per_y}}{Guarantees no more than one \eqn{x} in \code{A} exists for each \eqn{y} in \code{B} such that \eqn{y = F(x)}. Returns an error if B contains duplicate elements.}
}
\strong{Relation types}
\describe{
  \item{\code{relation_type = "one_to_one"}}{One-to-one relations require that each element in the domain to map to at most one element in the codomain, and each element of the codomain to map from the only one element in the domain. There may still be elements in \code{A} that do not have a mapping to an element in \code{B}, and vice versa. This is equivalent to
\code{restrictions = list("min_one_y_per_x" = FALSE,
"min_one_x_per_y" = FALSE,
"max_one_y_per_x" = TRUE,
"max_one_x_per_y" = TRUE)}}
  \item{\code{relation_type = "many_to_many"}}{Many-to-many relations allow multiple elements in the domain to map to the same element of the codomain, and multiple elements of the codomain to map from the same element of the domain. This is equivalent to
\code{restrictions = list("min_one_y_per_x" = FALSE,
"min_one_x_per_y" = FALSE,
"max_one_y_per_x" = FALSE,
"max_one_x_per_y" = FALSE)}}
  \item{\code{relation_type = "one_to_many"}}{One-to-many relations require each element of the domain to map to a distinct set of one or more elements in the codomain. This is equivalent to
\code{restrictions = list("min_one_y_per_x" = FALSE,
"min_one_x_per_y" = FALSE,
"max_one_y_per_x" = FALSE,
"max_one_x_per_y" = TRUE)}}
  \item{\code{relation_type = "many_to_one"}}{Many-to-one relations allows sets of one or more elements in the domain to map to the same distinct element in the codomain. This is equivalent to
\code{restrictions = list("min_one_y_per_x" = FALSE,
"min_one_x_per_y" = FALSE,
"max_one_y_per_x" = TRUE,
"max_one_x_per_y" = FALSE)}}
\item{\code{relation_type = "func"}}{Functions map each element in the domain to exactly one element in the codomain. This is equivalent to
\code{restrictions = list("min_one_y_per_x" = TRUE,
"min_one_x_per_y" = FALSE,
"max_one_y_per_x" = TRUE,
"max_one_x_per_y" = FALSE)}}
\item{\code{relation_type = "injection"}}{A function is injective if every element of the domain maps to a unique element of the codomain. This is equivalent to
\code{restrictions = list("min_one_y_per_x" = TRUE,
"min_one_x_per_y" = FALSE,
"max_one_y_per_x" = TRUE,
"max_one_x_per_y" = TRUE)}}
\item{\code{relation_type = "surjection"}}{A function is surjective if every element of the codomain maps from an element of the domain. This is equivalent to
\code{restrictions = list("min_one_y_per_x" = TRUE,
"min_one_x_per_y" = TRUE,
"max_one_y_per_x" = TRUE,
"max_one_x_per_y" = FALSE)}}
\item{\code{relation_type = "bijection"}}{A function is bijective if it is both injective and surjective, i.e. a complete one-to-one mapping. This is equivalent to
\code{restrictions = list("min_one_y_per_x" = TRUE,
"min_one_x_per_y" = TRUE,
"max_one_y_per_x" = TRUE,
"max_one_x_per_y" = TRUE)}}
}
}
\examples{
## Map from one vector to another
relate(c("a", "e", "i", "o", "u"), letters, LETTERS)
# [1] "A" "E" "I" "O" "U"
## or
caps <- relation(letters, LETTERS)
caps("t")
# [1] "T"
caps(c("p", "q", "r"))
# [1] "P" "Q" "R"

## Create a new column in a data frame
df <- data.frame(
name = c("Alice", "Bob", "Charlotte", "Dan", "Elise", "Frank"),
position = c("right", "lean-left", "left", "left", "lean-right", "no response")
)
positions <- c("left", "lean-left", "independent", "lean-right", "right")
colours <- c("darkblue", "lightblue", "green", "lightred", "darkred")
df$colour <- relate(df$position, positions, colours, default = "gray")
df
#        name     position    colour
# 1     Alice        right   darkred
# 2       Bob    lean-left lightblue
# 3 Charlotte         left  darkblue
# 4       Dan         left  darkblue
# 5     Elise   lean-right  lightred
# 6     Frank  no response      gray

## Authors have a many-to-many relation with books:
## a book can have multiple authors and authors can write multiple books
my_library <- data.frame(
  author = c(
    "Arendt",
    "Austen-Smith",
    "Austen-Smith",
    "Austen-Smith",
    "Banks",
    "Banks",
    "Camus",
    "Camus",
    "Arendt",
    "Dryzek",
    "Dunleavy"
  ),
  work = c(
    "The Human Condition",
    "Social Choice and Voting Models",
    "Information Aggregation, Rationality, and the Condorcet Jury Theorem",
    "Positive Political Theory I",
    "Information Aggregation, Rationality, and the Condorcet Jury Theorem",
    "Positive Political Theory I",
    "The Myth of Sisyphus",
    "The Rebel",
    "The Origins of Totalitarianism",
    "Theories of the Democratic State",
    "Theories of the Democratic State"
  ),
  stringsAsFactors = FALSE
)
relate(
  X = c("Arendt", "Austen-Smith", "Banks", "Dryzek", "Dunleavy"),
  A = my_library$author,
  B = my_library$work,
  atomic = FALSE,
  named = TRUE,
  relation_type = "many_to_many"
)
# $Arendt
# [1] "The Human Condition"            "The Origins of Totalitarianism"
#
# $`Austen-Smith`
# [1] "Social Choice and Voting Models"
# [2] "Information Aggregation, Rationality, and the Condorcet Jury Theorem"
# [3] "Positive Political Theory I"
#
# $Banks
# [1] "Information Aggregation, Rationality, and the Condorcet Jury Theorem"
# [2] "Positive Political Theory I"
#
# $Dryzek
# [1] "Theories of the Democratic State"
#
# $Dunleavy
# [1] "Theories of the Democratic State"

## Duplicate mappings will return multiple copies by default:
relate(
  X = 1:3,
  A = c(1, 2, 2, 3, 4, 5),
  B = c('a', 'b', 'b', 'c', 'd', 'e'),
  relation_type = "many_to_many",
  atomic = FALSE
)
# [[1]]
# [1] "a"
#
# [[2]]
# [1] "b" "b"
#
# [[3]]
# [1] "c"

## Use handle_duplicate_mappings = TRUE to ignore these and avoid mapping errors.
nums_to_letters <- relation(
  A = c(1, 2, 2, 3, 4, 5),
  B = c('a', 'b', 'b', 'c', 'd', 'e'),
  relation_type = "bijection",
  handle_duplicate_mappings = TRUE
)
nums_to_letters(X = c(1, 2, 3))
# [1] "a" "b" "c"

## Use relation with report_properties = TRUE to determine the properties of specified relation
domain <- -3:3
image <- domain^2
relation(domain, image, report_properties = TRUE)
# Relation properties:
# min_one_y_per_x min_one_x_per_y max_one_y_per_x max_one_x_per_y
# TRUE            TRUE            TRUE           FALSE
}
