{smcl}
{* *! version 1.1.0  24aug2017}{...}
{cmd:help xtpurt}{right: ({browse "http://www.stata-journal.com/article.html?article=st0519":SJ18-1: st0519})}
{hline}

{title:Title}

{p2colset 5 15 17 2}{...}
{p2col :{cmd:xtpurt} {hline 2}}Panel unit-root tests for heteroskedastic panels{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:xtpurt}
{varname}
{ifin}
[{cmd:,} {it:options}]

{synoptset 25}{...}
{synopthdr}
{synoptline}
{synopt:{opt test(testname)}}specify unit-root test to be applied; default is {cmd:test(hs)}{p_end}
{synopt:{opt t:rend}}include a time trend{p_end}
{synopt:{opt nocon:stant}}suppress panel-specific means{p_end}
{synopt:{opt lagsel(method)}}specify lag-order selection method; default is {cmd:lagsel(bic)}{p_end}
{synopt:{opt max:lags(#)}}specify maximum lag order; default is {cmd:maxlags(4)}{p_end}
{synopt:{opt lagsex:port(newvar)}}export lag structure to variable {it:newvar}{p_end}
{synopt:{opt lags(lagorders)}}set lag structure for prewhitening{p_end}
{synoptline}


{marker description}{...}
{title:Description}

{pstd}
{cmd:xtpurt} implements the heteroskedasticity-robust panel unit-root tests
(PURTs) suggested in Herwartz and Siedenburg (2008), Demetrescu and Hanck
(2012), and Herwartz, Maxand, and Walle (2017).  While the former two tests
are robust to time-varying volatility when the data contain only an intercept,
the latter test is asymptotically pivotal for trending heteroskedastic panels.
Special attention is paid to conform to the built-in Stata command
{cmd:xtunitroot}.  Moreover, {cmd:xtpurt} incorporates lag-order selection,
prewhitening, and detrending procedures to account for serial correlation and
trending data.  The function requires a balanced panel dataset in long format,
declared explicitly to be panel data -- see {helpb xtset}.  Here {varname}
specifies the variable name in the working space to be assessed for a unit
root.  Missing observations are not allowed.  Strictly speaking, the
first-order differences of the declared time variable (the time variable
delta) have to be constant.


{marker options}{...}
{title:Options}

{phang}
{opt test(testname)} specifies the testing method to be applied.  The three
tests described before are supported: Herwartz and Siedenburg (2008),
Demetrescu and Hanck (2012), and Herwartz, Maxand, and Walle (2017).  All
approaches can be called jointly, returning their results in a single output
table.  However, the test by Herwartz, Maxand, and Walle (2017) requires that
the option {cmd:trend} (see below) be set.  Accordingly, {it:testname} can be
{cmd:hs}, {cmd:dh}, {cmd:hmw}, or {cmd:all}.  The default is {cmd:test(hs)};
{cmd:test(hmw)} if {cmd:trend} is specified.

{phang}
{cmd:trend} adds a deterministic trend to the regression model.  This option
affects the lag-order selection, prewhitening, and detrending procedures.

{phang}
{cmd:noconstant} removes the constant in the regression model.  This option
cannot be combined with {cmd:trend} and might be rarely used in practice.  It
affects the lag-order selection, prewhitening, and detrending procedures.

{phang}
{opt lagsel(method)} sets the selection method for determining the lag order.
Internally, the function uses the built-in Stata command {cmd:varsoc}.  The
user can choose between the Akaike, Schwarz-Bayesian, or Hannan-Quinn
information criterion.  Accordingly, {it:method} can be {cmd:aic}, {cmd:bic},
or {cmd:hqic}.  The default is {cmd:lagsel(bic)}.

{phang}
{opt maxlags(#)} specifies the maximum lag order when determining the lag
orders per panel for the prewhitening procedure by means of a selection
criterion -- see the option {opt lagsel(method)}.  See the option 
{opt lags(lagorders)} for setting fixed lag orders.  The default is
{cmd:maxlags(4)}.

{phang}
{opt lagsexport(newvar)} generates a new integer variable, {it:newvar}, in the
workspace containing the lag orders per panel, which were used in the
prewhitening procedure.  This variable might then be used for further
analysis; it can be edited or set as input in the option 
{opt lags(lagorders)}.  By default, {cmd:lagsexport()} is not set, and no
variable will be created.

{phang}
{opt lags(lagorders)} allows the specification of fixed lag orders for the
prewhitening procedure.  Either {it:lagorders} is a scalar integer that can be
used to set one common fixed lag length for all panels, or the user can refer
to a variable containing fixed lag orders per panel.  This variable's format
is the same as the output's format of option {opt lagsexport(newvar)}.  Hence,
any user-preferred lag-order selection method might be applied before, or
prewhitening can be disabled by setting {it:lagorders} to 0.  By default,
{cmd:lags()} is not set, and {cmd:xtpurt} applies a lag-order selection
criterion per panel -- see the options {opt lagsel(method)} and 
{opt maxlags(#)}.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
The sample will be rebalanced after prewhitening the panels with their preset
or determined lag orders.  While {cmd:Number of periods} indicates the number
of observations per panel used for prewhitening, the specification 
{cmd:After rebalancing} refers to the number of recent observations that are
actually used for (detrending and) testing.{p_end}

{p 4 4 2}
The display {cmd:Prewhitening} specifies whether the lag order used for
prewhitening was detected automatically ({cmd:AIC}, {cmd:BIC}, or {cmd:HQIC};
see {opt lagsel(method)} and {opt maxlags(#)}) or was set manually by the user
via {opt lags(lagorders)} ({cmd:FIX}).  {cmd:Lag orders} indicates the
smallest ({cmd:min}) and largest ({cmd:max}) lag orders used per panel for the
prewhitening procedure.  These values are determined as the minimum and
maximum of the stored lag vector {cmd:r(lags)}.{p_end}


{marker examples}{...}
{title:Examples}

{phang}{cmd:. use xtpurtdata}

{phang}{cmd:. generate lprices = log(prices)}{p_end}

{phang}{cmd:. generate dlprices = D.lprices}{p_end}

{phang}{cmd:. xtpurt lprices}{p_end}

{phang}{cmd:. xtpurt lprices, trend}{p_end}

{phang}{cmd:. xtpurt lprices, test(all) trend maxlags(9)}{p_end}

{phang}{cmd:. xtpurt dlprices, test(all) maxlags(9)}{p_end}

{phang}{cmd:. xtpurt dlprices, test(all) maxlags(9) lagsexport(lorders)}{p_end}

{phang}{cmd:. xtpurt dlprices, test(all) lags(lorders)}{p_end}


{marker results}{...}
{title:Stored Results}

{pstd}
{cmd:xtpurt} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(N_g)}}number of panels{p_end}
{synopt:{cmd:r(N_t)}}number of time periods{p_end}
{synopt:{cmd:r(N_r)}}number of time periods after rebalancing{p_end}
{synopt:{cmd:r(t_hs)}}Herwartz and Siedenburg test statistic{p_end}
{synopt:{cmd:r(t_hs_p)}}p-value for Herwartz and Siedenburg test statistic{p_end}
{synopt:{cmd:r(t_dh)}}Demetrescu and Hanck test statistic{p_end}
{synopt:{cmd:r(t_dh_p)}}p-value for Demetrescu and Hanck test statistic{p_end}
{synopt:{cmd:r(t_hmw)}}Herwartz, Maxand, and Walle test statistic{p_end}
{synopt:{cmd:r(t_hmw_p)}}p-value for Herwartz, Maxand, and Walle test statistic{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(test)}}{cmd:hs}, {cmd:dh}, {cmd:hmw}, or {cmd:all}{p_end}
{synopt:{cmd:r(determ)}}{cmd:noconstant}, {cmd:constant}, or {cmd:trend}{p_end}
{synopt:{cmd:r(lagsel)}}{cmd:aic}, {cmd:bic}, {cmd:hqic}, or {cmd:fix}{p_end}
{synopt:{cmd:r(warnings)}}caution message as string, if warning occurred{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(lags)}}vector containing the lag orders per panel used for the prewhitening procedure{p_end}
{p2colreset}{...}


{marker citation}{...}
{title:Citation}

{p 4 4 2}
{cmd:xtpurt} is not an official Stata command.  If you use {cmd:xtpurt}, please
cite{p_end}

{p 8 12 2}Herwartz, H., S. Maxand, F. H. C. Raters, and Y. M. Walle. 2017.
{browse "http://www.stata-journal.com/article.html?article=st0519":Panel unit-root tests for heteroskedastic panels}.
{it:Stata Journal} 18: 184-196.{p_end}


{marker references}{...}
{title:References}

{p 4 8 2}
Demetrescu, M., and C. Hanck. 2012. A simple nonstationary-volatility robust
panel unit root test. {it:Economics Letters} 117: 10-13.{p_end}

{p 4 8 2}
Herwartz, H., S. Maxand, and Y. M. Walle. 2017. Heteroskedasticity-robust unit
root testing for trending panels. Center for European, Governance and
Economic Development Research Discussion Papers 314, University of Goettingen,
Department of Economics.
{browse "http://econpapers.repec.org/paper/zbwcegedp/314.htm"}.{p_end}

{p 4 8 2}
Herwartz, H., and F. Siedenburg. 2008. Homogenous panel unit root tests under
cross sectional dependence: Finite sample modifications and the wild
bootstrap. {it:Computational Statistics and Data Analysis} 53: 137-150.{p_end}


{title:Authors}

{pstd}
Helmut Herwartz{break}
University of Goettingen{break}
Goettingen, Germany

{pstd}
Simone Maxand{break}
University of Goettingen{break}
Goettingen, Germany

{pstd}
Fabian H. C. Raters{break}
University of Goettingen{break}
Goettingen, Germany{break}
raters@uni-goettingen.de

{pstd}
Yabibal M. Walle{break}
University of Goettingen{break}
Goettingen, Germany


{title:Also see}

{p 4 14 2}
Article:  {it:Stata Journal}, volume 18, number 1: {browse "http://www.stata-journal.com/article.html?article=st0519":st0519}{p_end}

{p 7 14 2}
Help:  {manhelp xtunitroot XT},
{manhelp xtset XT},
{manhelp xtsum XT}{p_end}
