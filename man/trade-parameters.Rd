% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/binance.R
\name{trade-parameters}
\alias{trade-parameters}
\title{Parameters for trade functions}
\arguments{
\item{coin}{Coin.}

\item{symbol}{Symbol.}

\item{start_time}{Start time. Something that can be coerced to \code{POSIXct}.}

\item{end_time}{End time. Something that can be coerced to \code{POSIXct}.}

\item{interval}{Time interval. One  of 1m, 3m, 5m, 15m, 30m, 1h, 2h, 4h, 6h,
8h, 12h, 1d, 3d, 1w or 1M where m = minutes, h = hours, d = days,
w = weeks and M = months.}

\item{type}{Order type. One of \code{"SPOT"}, \code{"MARGIN"} or \code{"FUTURES"}.}

\item{order_type}{Order type. One of \code{"LIMIT"}, \code{"MARKET"},
\code{"STOP_LOSS"}, \code{"STOP_LOSS_LIMIT"}, \code{"TAKE_PROFIT"},
\code{"TAKE_PROFIT_LIMIT"} or \code{"LIMIT_MAKER"}.}

\item{network}{Blockchain network.}

\item{fiat}{Fiat currency.}

\item{side}{Side of the trade: \code{"BUY"} or \code{"SELL"}.}
}
\description{
Parameters for trade functions
}
