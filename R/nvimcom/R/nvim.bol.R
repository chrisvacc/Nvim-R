#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  A copy of the GNU General Public License is available at
#  http://www.r-project.org/Licenses/

### Jakson Alves de Aquino
### Tue, January 18, 2011

# This function writes two files: one with the names of all functions in all
# packages (either loaded or installed); the other file lists all objects,
# including function arguments. These files are used by Vim to highlight
# functions and to complete the names of objects and the arguments of
# functions.

nvim.grepl <- function(pattern, x) {
    res <- grep(pattern, x)
    if(length(res) == 0){
        return(FALSE)
    } else {
        return(TRUE)
    }
}

nvim.omni.line <- function(x, envir, printenv, curlevel, maxlevel = 0, spath = FALSE) {
    if(curlevel == 0){
        xx <- try(get(x, envir), silent = TRUE)
        if(inherits(xx, "try-error"))
            return(invisible(NULL))
    } else {
        x.clean <- gsub("$", "", x, fixed = TRUE)
        x.clean <- gsub("_", "", x.clean, fixed = TRUE)
        haspunct <- nvim.grepl("[[:punct:]]", x.clean)
        if(haspunct[1]){
            ok <- nvim.grepl("[[:alnum:]]\\.[[:alnum:]]", x.clean)
            if(ok[1]){
                haspunct  <- FALSE
                haspp <- nvim.grepl("[[:punct:]][[:punct:]]", x.clean)
                if(haspp[1]) haspunct <- TRUE
            }
        }

        # No support for names with spaces
        if(nvim.grepl(" ", x)){
            haspunct <- TRUE
        }

        if(haspunct[1]){
            xx <- NULL
        } else {
            xx <- try(eval(parse(text=x)), silent = TRUE)
            if(class(xx)[1] == "try-error"){
                xx <- NULL
            }
        }
    }

    if(is.null(xx)){
        x.group <- " "
        x.class <- "unknown"
    } else {
        if(x == "break" || x == "next" || x == "for" || x == "if" || x == "repeat" || x == "while"){
            x.group <- "flow-control"
            x.class <- "flow-control"
        } else {
            if(is.function(xx)) x.group <- "function"
            else if(is.numeric(xx)) x.group <- "numeric"
            else if(is.factor(xx)) x.group <- "factor"
            else if(is.character(xx)) x.group <- "character"
            else if(is.logical(xx)) x.group <- "logical"
            else if(is.data.frame(xx)) x.group <- "data.frame"
            else if(is.list(xx)) x.group <- "list"
            else if(is.environment(xx)) x.group <- "env"
            else x.group <- " "
            x.class <- class(xx)[1]
        }
    }

    if(curlevel == maxlevel || maxlevel == 0){
        if(x.group == "function"){
            if(curlevel == 0){
                if(nvim.grepl("GlobalEnv", printenv)){
                    cat(x, "\x06function\x06function\x06", printenv, "\x06",
                        nvim.args(x, txt = "", spath = spath), "\n", sep = "")
                } else {
                    info <- ""
                    try(info <- NvimcomEnv$pkgdescr[[printenv]]$descr[[NvimcomEnv$pkgdescr[[printenv]]$alias[[x]]]],
                        silent = TRUE)
                    cat(x, "\x06function\x06function\x06", printenv, "\x06",
                        nvim.args(x, txt = "", pkg = printenv, spath = spath), info, "\n", sep = "")
                }
            } else {
                # some libraries have functions as list elements
                cat(x, "\x06function\x06function\x06", printenv, "\x06Unknown arguments", "\n", sep="")
            }
        } else {
            if(is.list(xx) || is.environment(xx)){
                if(curlevel == 0){
                    info <- ""
                    try(info <- NvimcomEnv$pkgdescr[[printenv]]$descr[[NvimcomEnv$pkgdescr[[printenv]]$alias[[x]]]],
                        silent = TRUE)
                    cat(x, "\x06", x.class, "\x06", x.group, "\x06", printenv, "\x06Not a function", info, "\n", sep="")
                } else {
                    cat(x, "\x06", x.class, "\x06", " ", "\x06", printenv, "\x06Not a function", "\n", sep="")
                }
            } else {
                info <- ""
                try(info <- NvimcomEnv$pkgdescr[[printenv]]$descr[[NvimcomEnv$pkgdescr[[printenv]]$alias[[x]]]],
                        silent = TRUE)
                cat(x, "\x06", x.class, "\x06", x.group, "\x06", printenv, "\x06Not a function", info, "\n", sep="")
            }
        }
    }

    if((is.list(xx) || is.environment(xx)) && curlevel <= maxlevel){
        obj.names <- names(xx)
        curlevel <- curlevel + 1
        xxl <- length(xx)
        if(!is.null(xxl) && xxl > 0){
            for(k in obj.names){
                nvim.omni.line(paste(x, "$", k, sep=""), envir, printenv, curlevel, maxlevel, spath)
            }
        }
    } else if(isS4(xx) && curlevel <= maxlevel){
        obj.names <- slotNames(xx)
        curlevel <- curlevel + 1
        xxl <- length(xx)
        if(!is.null(xxl) && xxl > 0){
            for(k in obj.names){
                nvim.omni.line(paste(x, "@", k, sep=""), envir, printenv, curlevel, maxlevel, spath)
            }
        }
    }
}

CleanOmniLineASCII <- function(x)
{
    x <- gsub("\\\\R", "R", x)
    x <- gsub("\\\\link\\{(.+?)\\}", "\\1", x)
    x <- gsub("\\\\link\\[.+?\\]\\{(.+?)\\}", "\\1", x)
    x <- gsub("\\\\code\\{(.+?)\\}", "'\\1'", x)
    x <- gsub("\\\\samp\\{(.+?)\\}", "'\\1'", x)
    x <- gsub("\\\\file\\{(.+?)\\}", "'\\1'", x)
    x <- gsub("\\\\sQuote\\{(.+?)\\}", "'\\1'", x)
    x <- gsub("\\\\dQuote\\{(.+?)\\}", '"\\1"', x)
    x <- gsub("\\\\emph\\{(.+?)\\}", "\\1", x)
    x <- gsub("\\\\bold\\{(.+?)\\}", "\\1", x)
    x <- gsub("\\\\pkg\\{(.+?)\\}", "\\1", x)
    x <- gsub("\\\\item\\{(.+?)\\}", "\\1", x)
    x <- gsub("\\\\item ", "\\\\N  - ", x)
    x <- gsub("\\\\itemize\\{(.+?)\\}", "\\1", x)
    x <- gsub("\\\\eqn\\{.+?\\}\\{(.+?)\\}", "\\1", x)
    x <- gsub("\\\\eqn\\{(.+?)\\}", "\\1", x)
    x <- gsub("\\\\cite\\{(.+?)\\}", "\\1", x)
    x <- gsub("\\\\url\\{(.+?)\\}", "\\1", x)
    x <- gsub("\\\\linkS4class\\{(.+?)\\}", "\\1", x)
    x <- gsub("\\\\command\\{(.+?)\\}", "`\\1`", x)
    x <- gsub("\\\\href\\{\\{.+?\\}\\{(.+?)\\}\\}", "'\\1'", x)
    x <- gsub("\\\\ifelse\\{\\{latex\\}\\{\\\\out\\{.\\}\\}\\{ \\}\\}\\{\\}", " ", x) # \sspace
    x <- gsub("\\\\ldots", "...", x)
    x <- gsub("\\\\dots", "...", x)
    x <- gsub("\\\\preformatted\\{(.+?)\\}", "\\\\N\\1\\\\N", x)
    x
}

CleanOmniLineUTF8 <- function(x)
{
    x <- gsub("\\\\R", "R", x)
    x <- gsub("\\\\link\\{(.+?)\\}", "\\1", x)
    x <- gsub("\\\\link\\[.+?\\]\\{(.+?)\\}", "\\1", x)
    x <- gsub("\\\\code\\{(.+?)\\}", "\u2018\\1\u2019", x)
    x <- gsub("\\\\samp\\{(.+?)\\}", "\u2018\\1\u2019", x)
    x <- gsub("\\\\file\\{(.+?)\\}", "\u2018\\1\u2019", x)
    x <- gsub("\\\\sQuote\\{(.+?)\\}", "\u2018\\1\u2019", x)
    x <- gsub("\\\\dQuote\\{(.+?)\\}", "\u201c\\1\u201d", x)
    x <- gsub("\\\\emph\\{(.+?)\\}", "\\1", x)
    x <- gsub("\\\\bold\\{(.+?)\\}", "\\1", x)
    x <- gsub("\\\\pkg\\{(.+?)\\}", "\\1", x)
    x <- gsub("\\\\item\\{(.+?)\\}", "\\1", x)
    x <- gsub("\\\\item ", "\\\\N  \u2022 ", x)
    x <- gsub("\\\\itemize\\{(.+?)\\}", "\\1", x)
    x <- gsub("\\\\eqn\\{.+?\\}\\{(.+?)\\}", "\\1", x)
    x <- gsub("\\\\eqn\\{(.+?)\\}", "\\1", x)
    x <- gsub("\\\\cite\\{(.+?)\\}", "\\1", x)
    x <- gsub("\\\\url\\{(.+?)\\}", "\\1", x)
    x <- gsub("\\\\linkS4class\\{(.+?)\\}", "\\1", x)
    x <- gsub("\\\\command\\{(.+?)\\}", "`\\1`", x)
    x <- gsub("\\\\href\\{\\{.+?\\}\\{(.+?)\\}\\}", "\u2018\\1\u2019", x)
    x <- gsub("\\\\ifelse\\{\\{latex\\}\\{\\\\out\\{.\\}\\}\\{ \\}\\}\\{\\}", " ", x) # \sspace
    x <- gsub("\\\\ldots", "...", x)
    x <- gsub("\\\\dots", "...", x)
    x <- gsub("\\\\preformatted\\{(.+?)\\}", "\\\\N\\1\\\\N", x)
    x
}

if(!is.na(localeToCharset()) && localeToCharset()[1] == "UTF-8" && version$os != "cygwin"){
    CleanOmniLine <- CleanOmniLineUTF8
} else {
    CleanOmniLine <- CleanOmniLineASCII
}

# Code adapted from the gbRd package
GetFunDescription <- function(pkg)
{
    pth <- attr(packageDescription(pkg), "file")
    pth <- sub("Meta/package.rds", "", pth)
    pth <- paste0(pth, "help/")
    idx <- paste0(pth, "AnIndex")

    # Development packages might not have any written documentation yet
    if(!file.exists(idx) || !file.info(idx)$size)
        return(NULL)

    tab <- read.table(idx, sep = "\t", quote = "", stringsAsFactors = FALSE)
    als <- tab$V2
    names(als) <- tab$V1

    if(!file.exists(paste0(pth, pkg, ".rdx")))
        return(NULL)
    pkgInfo <- tools:::fetchRdDB(paste0(pth, pkg))

    GetDescr <- function(x)
    {
        x <- paste0(x, collapse = "")
        ttl <- sub(".*\\\\title\\{\\s*", "", x)
        ttl <- sub("\n", " ", ttl)
        ttl <- gsub("  +", " ", ttl)
        ttl <- CleanOmniLine(ttl)
        ttl <- sub("\\s*\\}.*", "", ttl)
        ttl <- gsub("\\{", "", ttl)
        x <- sub(".*\\\\description\\{\\s*", "", x)
        xc <- charToRaw(x)
        k <- 1
        i <- 1
        l <- length(xc)
        while(i < l)
        {
            if(xc[i] == 123){
                k <- k + 1
            }
            if(xc[i] == 125){
                k <- k - 1
            }
            if(k == 0){
                x <- rawToChar(xc[1:i-1])
                break
            }
            i <- i + 1
        }

        x <- sub("^\\s*", "", sub("\\s*$", "", x))
        x <- gsub("\n\\s*", "\\\\N", x)
        x <- paste0("\x08", ttl, "\x05", x)
        x
    }
    NvimcomEnv$pkgdescr[[pkg]] <- list("descr" = sapply(pkgInfo, GetDescr),
                                       "alias" = als)
}

CleanOmnils <- function(f)
{
    x <- readLines(f)
    x <- CleanOmniLine(x)
    writeLines(x, f)
}


# Build Omni List
nvim.bol <- function(omnilist, packlist, allnames = FALSE, pattern = "", sendmsg = 1) {
    nvim.OutDec <- getOption("OutDec")
    on.exit(options(nvim.OutDec))
    options(OutDec = ".")

    if(!missing(packlist) && is.null(NvimcomEnv$pkgdescr[[packlist]]))
        GetFunDescription(packlist)

    if(omnilist == ".GlobalEnv"){
        sink(paste0(Sys.getenv("NVIMR_TMPDIR"), "/GlobalEnvList_", Sys.getenv("NVIMR_ID")), append = FALSE)
        for(env in search()){
            if(grepl("^package:", env) == FALSE){
                obj.list <- objects(env, all.names = allnames)
                l <- length(obj.list)
                maxlevel <- nchar(pattern) - nchar(gsub("@", "", gsub("\\$", "", pattern)))
                pattern <- sub("\\$.*", "", pattern)
                pattern <- sub("@.*", "", pattern)
                if(l > 0)
                    for(obj in obj.list)
                        if(length(grep(paste0("^", pattern), obj)) > 0)
                            nvim.omni.line(obj, env, env, 0, maxlevel, spath = TRUE)
            }
        }
        sink()
        writeLines(text = paste(obj.list, collapse = "\n"),
                   con = paste(Sys.getenv("NVIMR_TMPDIR"), "/nvimbol_finished", sep = ""))
        flush(stdout())
        if(sendmsg == 1){
            .C("nvimcom_msg_to_nvim", "FinishBuildROmniList()", PACKAGE = "nvimcom")
        } else if(sendmsg == 2){
            .C("nvimcom_msg_to_nvim", "CheckRGlobalEnv()", PACKAGE = "nvimcom")
        }
        return(invisible(NULL))
    }

    if(getOption("nvimcom.verbose") > 3)
        cat("Building files with lists of objects in loaded packages for",
            "omni completion and Object Browser...\n")

    loadpack <- search()
    if(missing(packlist))
        listpack <- loadpack[grep("^package:", loadpack)]
    else
        listpack <- paste("package:", packlist, sep = "")

    needunload <- FALSE
    for(curpack in listpack){
        curlib <- sub("^package:", "", curpack)
        if(nvim.grepl(curlib, loadpack) == FALSE){
            cat("Loading   '", curlib, "'...\n", sep = "")
            needunload <- try(require(curlib, character.only = TRUE))
            if(needunload != TRUE){
                needunload <- FALSE
                next
            }
        }

        # Save title of package in pack_descriptions:
        if(file.exists(paste0(Sys.getenv("NVIMR_COMPLDIR"), "/pack_descriptions")))
            pack_descriptions <- readLines(paste0(Sys.getenv("NVIMR_COMPLDIR"),
                                                  "/pack_descriptions"))
        else
            pack_descriptions <- character()
        pack_descriptions <- c(paste(curlib,
                           gsub("[\t\n ]+", " ", packageDescription(curlib)$Title),
                           gsub("[\t\n ]+", " ", packageDescription(curlib)$Description),
                           sep = "\x09"), pack_descriptions)
        pack_descriptions <- sort(pack_descriptions[!duplicated(pack_descriptions)])
        writeLines(pack_descriptions,
                   paste0(Sys.getenv("NVIMR_COMPLDIR"), "/pack_descriptions"))

        obj.list <- objects(curpack, all.names = allnames)
        l <- length(obj.list)
        if(l > 0){
            sink(omnilist, append = FALSE)
            for(obj in obj.list){
                ol <- try(nvim.omni.line(obj, curpack, curlib, 0))
                if(inherits(ol, "try-error"))
                    warning(paste("Error while generating omni completion line for: ",
                                  obj, " (", curpack, ", ", curlib, ").\n", sep = ""))
            }
            sink()
            CleanOmnils(omnilist)
            # Build list of functions for syntax highlight
            fl <- readLines(omnilist)
            fl <- fl[grep("\x06function\x06function", fl)]
            fl <- sub("\x06.*", "", fl)
            fl <- fl[!grepl("[<%\\[\\+\\*&=\\$:{|@\\(\\^>/~!]", fl)]
            fl <- fl[!grepl("-", fl)]
            if(curlib == "base"){
                fl <- fl[!grepl("^array$", fl)]
                fl <- fl[!grepl("^attach$", fl)]
                fl <- fl[!grepl("^character$", fl)]
                fl <- fl[!grepl("^complex$", fl)]
                fl <- fl[!grepl("^data.frame$", fl)]
                fl <- fl[!grepl("^detach$", fl)]
                fl <- fl[!grepl("^double$", fl)]
                fl <- fl[!grepl("^function$", fl)]
                fl <- fl[!grepl("^integer$", fl)]
                fl <- fl[!grepl("^library$", fl)]
                fl <- fl[!grepl("^list$", fl)]
                fl <- fl[!grepl("^logical$", fl)]
                fl <- fl[!grepl("^matrix$", fl)]
                fl <- fl[!grepl("^numeric$", fl)]
                fl <- fl[!grepl("^require$", fl)]
                fl <- fl[!grepl("^source$", fl)]
                fl <- fl[!grepl("^vector$", fl)]
            }
            if(length(fl) > 0){
                fl <- paste("syn keyword rFunction", fl)
                writeLines(text = fl, con = sub("omnils_", "fun_", omnilist))
            } else {
                writeLines(text = '" No functions found.', con = sub("omnils_", "fun_", omnilist))
            }
        } else {
            writeLines(text = '', con = omnilist)
            writeLines(text = '" No functions found.', con = sub("omnils_", "fun_", omnilist))
        }
        if(needunload){
            cat("Detaching '", curlib, "'...\n", sep = "")
            try(detach(curpack, unload = TRUE, character.only = TRUE), silent = TRUE)
            needunload <- FALSE
        }
    }
    writeLines(text = "Finished",
               con = paste(Sys.getenv("NVIMR_TMPDIR"), "/nvimbol_finished", sep = ""))
    return(invisible(NULL))
}

nvim.buildomnils <- function(p){
    pvi <- utils::packageDescription(p)$Version
    bdir <- paste0(Sys.getenv("NVIMR_COMPLDIR"), "/")
    odir <- dir(bdir)
    pbuilt <- odir[grep(paste0("omnils_", p, "_"), odir)]
    fbuilt <- odir[grep(paste0("fun_", p, "_"), odir)]

    # This option might not have been set if R is running remotely
    if(is.null(getOption("nvimcom.verbose")))
        options(nvimcom.verbose = 0)

    if(length(pbuilt) > 0){
        pvb <- sub(".*_.*_", "", pbuilt)
        if(pvb == pvi){
            if(file.info(paste0(bdir, "/README"))$mtime > file.info(paste0(bdir, pbuilt))$mtime){
                unlink(c(paste0(bdir, pbuilt), paste0(bdir, fbuilt)))
                nvim.bol(paste0(bdir, "omnils_", p, "_", pvi), p, TRUE)
                if(getOption("nvimcom.verbose") > 3)
                    cat("nvimcom R: omnils is older than the README\n")
            } else{
                if(getOption("nvimcom.verbose") > 3)
                    cat("nvimcom R: omnils version is up to date:", p, pvi, "\n")
            }
        } else {
            if(getOption("nvimcom.verbose") > 3)
                cat("nvimcom R: omnils is outdated: ", p, " (", pvb, " x ", pvi, ")\n", sep = "")
            unlink(c(paste0(bdir, pbuilt), paste0(bdir, fbuilt)))
            nvim.bol(paste0(bdir, "omnils_", p, "_", pvi), p, TRUE)
        }
    } else {
        if(getOption("nvimcom.verbose") > 3)
            cat("nvimcom R: omnils does not exist:", p, "\n")
        nvim.bol(paste0(bdir, "omnils_", p, "_", pvi), p, TRUE)
    }
}
