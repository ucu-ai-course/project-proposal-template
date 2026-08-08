%% ucuproposal.cls
%% Клас для пропоузалів семестрових проєктів курсу «Штучний інтелект» (УКУ).
%% Уся верстка та брендинг живуть тут — main.tex містить лише метадані й контент.
%% Вимагає компіляції XeLaTeX (fontspec + polyglossia).

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ucuproposal}[2026/01/01 v1.0 UCU semester project proposal template]

\RequirePackage{etoolbox}

%% ------------------------------------------------------------------
%% Опції класу
%% ------------------------------------------------------------------
\newtoggle{ucu@english}
\togglefalse{ucu@english}
\newtoggle{ucu@slogan}
\togglefalse{ucu@slogan}

\DeclareOption{ukrainian}{\togglefalse{ucu@english}}
\DeclareOption{english}{\toggletrue{ucu@english}}
\DeclareOption{slogan}{\toggletrue{ucu@slogan}}
\DeclareOption*{%
  \ClassWarningNoLine{ucuproposal}{Невідома опція класу '\CurrentOption' буде проігнорована}%
}
\ExecuteOptions{ukrainian}
\ProcessOptions\relax

\LoadClass[10.5pt,a4paper]{article}

%% ------------------------------------------------------------------
%% Базові пакети
%% ------------------------------------------------------------------
\RequirePackage{geometry}
\geometry{a4paper,left=22mm,right=22mm,top=25mm,bottom=25mm,headheight=14pt,headsep=8mm}

\RequirePackage{fontspec}
\RequirePackage{polyglossia}

\iftoggle{ucu@english}{%
  \setdefaultlanguage{english}
  \setotherlanguage{ukrainian}
}{%
  \setdefaultlanguage{ukrainian}
  \setotherlanguage{english}
}

\RequirePackage{xcolor}
\RequirePackage{graphicx}
\RequirePackage{microtype}
\RequirePackage{titlesec}
\RequirePackage{enumitem}
\RequirePackage{booktabs}
\RequirePackage{array}
\RequirePackage{mdframed}
\RequirePackage{fancyhdr}
\RequirePackage{lastpage}
\RequirePackage{refcount}
\RequirePackage[backend=biber,style=numeric-comp,sorting=none]{biblatex}
\addbibresource{references.bib}

%% ------------------------------------------------------------------
%% Фірмовий колір УКУ (єдиний акцентний колір шаблону)
%% ------------------------------------------------------------------
\definecolor{ucured}{HTML}{7F1716}
\definecolor{ucutext}{HTML}{2B2B2B}
\definecolor{ucugray}{HTML}{8A8A8A}

\AtBeginDocument{\color{ucutext}}

%% ------------------------------------------------------------------
%% Шрифти: Charis SIL (текст) + Fira Sans (заголовки/титулка) + Fira Mono
%% Якщо гарнітура недоступна — явне попередження в лозі й безшумний fallback
%% на DejaVu, щоб компіляція ніколи не падала через шрифт.
%% ------------------------------------------------------------------
\newtoggle{ucu@mainfontsc}
\togglefalse{ucu@mainfontsc}

\IfFontExistsTF{Charis SIL}{%
  \setmainfont{Charis SIL}%
  \toggletrue{ucu@mainfontsc}%
}{%
  \ClassWarningNoLine{ucuproposal}{Шрифт 'Charis SIL' не знайдено. Використано резервний DejaVu Serif. Встановіть пакет TeX Live 'charissil' для коректного брендингу}%
  \IfFontExistsTF{DejaVu Serif}{\setmainfont{DejaVu Serif}}{%
    \ClassWarningNoLine{ucuproposal}{Резервний шрифт 'DejaVu Serif' також не знайдено. Використано типовий шрифт LaTeX}%
  }%
}

%% Малі капітелі для титулки: справжня OpenType-функція Charis SIL,
%% або класичний \scshape як безпечний резерв для інших шрифтів.
\newcommand{\ucu@sc}[1]{%
  \iftoggle{ucu@mainfontsc}{{\addfontfeature{Letters=SmallCaps}#1}}{{\scshape#1}}%
}

\IfFontExistsTF{Fira Sans}{%
  \setsansfont{Fira Sans}%
}{%
  \ClassWarningNoLine{ucuproposal}{Шрифт 'Fira Sans' не знайдено. Використано резервний DejaVu Sans. Встановіть пакет TeX Live 'fira' для коректного брендингу}%
  \IfFontExistsTF{DejaVu Sans}{\setsansfont{DejaVu Sans}}{%
    \ClassWarningNoLine{ucuproposal}{Резервний шрифт 'DejaVu Sans' також не знайдено. Використано типовий шрифт LaTeX}%
  }%
}

\IfFontExistsTF{Fira Mono}{%
  \setmonofont{Fira Mono}%
}{%
  \ClassWarningNoLine{ucuproposal}{Шрифт 'Fira Mono' не знайдено. Використано резервний DejaVu Sans Mono}%
  \IfFontExistsTF{DejaVu Sans Mono}{\setmonofont{DejaVu Sans Mono}}{}%
}

% Накреслення заголовків: у брендбуці — Fira Sans SemiBold.
% Якщо SemiBold недоступний окремою гарнітурою — резерв на Fira Sans Bold.
\IfFontExistsTF{Fira Sans SemiBold}{%
  \newfontfamily\ucuheadfont{Fira Sans SemiBold}%
}{%
  \ClassWarningNoLine{ucuproposal}{Накреслення 'Fira Sans SemiBold' не знайдено. Заголовки набрано Fira Sans Bold}%
  \newcommand{\ucuheadfont}{\sffamily\bfseries}%
}

\setlength{\parindent}{0pt}
\setlength{\parskip}{0.4em}
\linespread{1.15}

%% ------------------------------------------------------------------
%% Мовно-залежні підписи та ім'я файлу логотипу
%% ------------------------------------------------------------------
\iftoggle{ucu@english}{%
  \newcommand{\ucu@biblabel}{References}
  \newcommand{\ucu@labelteam}{Team}
  \newcommand{\ucu@labelmentor}{Mentor}
  \newcommand{\ucu@labelrepo}{Repository}
  \newcommand{\ucu@labeldate}{Submission date}
  \newcommand{\ucu@pagelabel}{page}
  \newcommand{\ucu@oflabel}{of}
  \newcommand{\ucu@superheader}{AI Course \textperiodcentered\ Semester Project Proposal \textperiodcentered\ 2026}
  \newcommand{\ucu@uniname}{Ukrainian Catholic University}
  \newcommand{\ucu@submittedline}{Project proposal submitted for the}
  \newcommand{\ucu@courseline}{\textquotedblleft Artificial Intelligence\textquotedblright\ course}
  \newcommand{\ucu@inthe}{in the}
  \newcommand{\ucu@facultyname}{Faculty of Applied Sciences}
}{%
  \newcommand{\ucu@biblabel}{Список джерел}
  \newcommand{\ucu@labelteam}{Команда}
  \newcommand{\ucu@labelmentor}{Ментор}
  \newcommand{\ucu@labelrepo}{Репозиторій}
  \newcommand{\ucu@labeldate}{Дата подачі}
  \newcommand{\ucu@pagelabel}{сторінка}
  \newcommand{\ucu@oflabel}{з}
  \newcommand{\ucu@superheader}{Курс «Штучний інтелект» \textperiodcentered\ Семестровий проєкт \textperiodcentered\ 2026}
  \newcommand{\ucu@uniname}{Український Католицький Університет}
  \newcommand{\ucu@submittedline}{Пропозиція проєкту, подана в межах курсу}
  \newcommand{\ucu@courseline}{«Штучний інтелект»}
  \newcommand{\ucu@inthe}{}
  \newcommand{\ucu@facultyname}{Факультет прикладних наук}
}

%% Печатка УКУ та лого факультету — поки лише в англомовному варіанті
%% (окремих українських версій файлів не надано), тому спільні для обох мов.
\newcommand{\ucu@sealfile}{assets/logo/uku_logo___seal_engl.png}
\newcommand{\ucu@facultylogofile}{assets/logo/Applied_Sciences_ENG.png}

%% Офіційне гасло УКУ. Формулювання не перекладається й не перефразовується
%% незалежно від мовної опції класу.
\newcommand{\ucu@slogantext}{%
  {\addfontfeature{LetterSpace=10.0}\color{ucured}\small СВІДЧИТИ. СЛУЖИТИ. СПІЛКУВАТИСЯ.}%
}

%% ------------------------------------------------------------------
%% Заголовки секцій: Fira Sans SemiBold 12pt, колір ucured, лише рівень 1
%% ------------------------------------------------------------------
\setcounter{secnumdepth}{1}
\setcounter{tocdepth}{1}

\titleformat{\section}
  {\normalfont\ucuheadfont\fontsize{12}{14}\selectfont\color{ucured}}
  {\thesection.}{0.5em}{}
\titlespacing*{\section}{0pt}{1.1em}{0.5em}

\titleformat{\subsection}
  {\normalfont\ucuheadfont\fontsize{10.5}{13}\selectfont\color{ucured}}
  {}{0pt}{}
\titlespacing*{\subsection}{0pt}{0.9em}{0.4em}

%% ------------------------------------------------------------------
%% Списки: компактні, маркер — маленький квадрат ucured
%% ------------------------------------------------------------------
\setlist[itemize]{nosep,leftmargin=1.2em,label={\color{ucured}\rule{0.8ex}{0.8ex}}}
\setlist[enumerate]{nosep,leftmargin=1.4em}

%% ------------------------------------------------------------------
%% Блок "keyfacts" — врізка з ключовими цифрами/метриками
%% ------------------------------------------------------------------
\newmdenv[
  topline=false,bottomline=false,rightline=false,leftline=true,
  linecolor=ucured,
  linewidth=2pt,
  innerleftmargin=10pt,innerrightmargin=10pt,
  innertopmargin=6pt,innerbottommargin=6pt,
  skipabove=8pt,skipbelow=8pt,
  backgroundcolor=white
]{keyfacts}

%% ------------------------------------------------------------------
%% hyperref (завантажується майже останнім)
%% ------------------------------------------------------------------
\RequirePackage{hyperref}
\hypersetup{
  colorlinks=true,
  allcolors=ucured,
  breaklinks=true,
  bookmarksnumbered=true,
}
\iftoggle{ucu@english}{\hypersetup{pdflang=en}}{\hypersetup{pdflang=uk}}
\urlstyle{same}

%% ------------------------------------------------------------------
%% Метадані пропоузалу: командний інтерфейс main.tex
%% ------------------------------------------------------------------
\newcommand{\projecttitle}[1]{\def\ucu@title{#1}}
\let\ucu@title\@empty

\newcommand{\projecttagline}[1]{\def\ucu@tagline{#1}}
\let\ucu@tagline\@empty

%% \par (не \\) навмисно: у p-колонці tabular з \centering ручний перенос \\
%% псує спільну базову лінію рядка таблиці відносно сусідньої комірки.
%% #1 = ім'я, #2 = URL профілю (може бути порожнім — тоді без посилання).
\newcommand{\ucu@teammemberline}[2]{%
  \def\ucu@linktmp{#2}%
  \ifx\ucu@linktmp\@empty
    \ucu@sc{\textbf{\color{ucured}#1}}\par\smallskip
  \else
    \href{#2}{\ucu@sc{\textbf{\color{ucured}#1}}}\par\smallskip
  \fi
}

\newcounter{ucu@nmembers}
\newcommand{\ucu@memberlist}{}
\newcommand{\ucu@authorlist}{}
%% Використання: \teammember{Ім'я Прізвище} або \teammember[URL]{Ім'я Прізвище}
%% (опційний URL, напр. LinkedIn-профіль, робить ім'я клікабельним посиланням).
\newcommand{\teammember}[2][]{%
  \stepcounter{ucu@nmembers}%
  \g@addto@macro\ucu@memberlist{\ucu@teammemberline{#2}{#1}}%
  \ifnum\value{ucu@nmembers}=1
    \renewcommand{\ucu@authorlist}{#2}%
  \else
    \g@addto@macro\ucu@authorlist{, #2}%
  \fi
  \ifnum\value{ucu@nmembers}>3
    \ClassWarningNoLine{ucuproposal}{У команді більше 3 учасників (\the\value{ucu@nmembers}). Методичка рекомендує 2--3 особи}%
  \fi
}

\newcommand{\mentor}[1]{\def\ucu@mentor{#1}}
\let\ucu@mentor\@empty

\newcommand{\track}[1]{\def\ucu@track{#1}}
\let\ucu@track\@empty

\newcommand{\repo}[1]{\def\ucu@repo{#1}}
\let\ucu@repo\@empty

\newcommand{\proposaldate}[1]{\def\ucu@date{#1}}
\let\ucu@date\@empty

\AtBeginDocument{%
  \hypersetup{pdftitle=\ucu@title,pdfauthor=\ucu@authorlist}%
}

%% ------------------------------------------------------------------
%% Валідація обов'язкових полів — людські повідомлення українською
%% ------------------------------------------------------------------
\newcommand{\ucu@checkrequired}{%
  \ifdefvoid{\ucu@title}{%
    \ClassError{ucuproposal}{Не задано назву проєкту. Додайте команду \string\projecttitle\space з назвою проєкту в аргументі у преамбулі main.tex}%
      {Додайте команду \string\projecttitle\space з назвою вашого проєкту в аргументі у преамбулі файлу main.tex, до початку документа.}%
  }{}%
  \ifnum\value{ucu@nmembers}=0
    \ClassError{ucuproposal}{Не вказано жодного учасника команди. Додайте щонайменше одну команду \string\teammember\space з ПІБ та роллю у преамбулі main.tex}%
      {Додайте щонайменше одну команду \string\teammember\space з ПІБ та роллю учасника у преамбулі файлу main.tex.}%
  \fi
  \ifdefvoid{\ucu@track}{}{%
    \ifdefstring{\ucu@track}{research}{}{%
      \ifdefstring{\ucu@track}{engineering}{}{%
        \ClassWarningNoLine{ucuproposal}{Невідоме значення \string\track: "\ucu@track". Очікується "research" або "engineering"}%
      }%
    }%
  }%
}

%% ------------------------------------------------------------------
%% Титульна сторінка
%% ------------------------------------------------------------------
\fancypagestyle{ucutitle}{%
  \fancyhf{}
  \renewcommand{\headrulewidth}{0pt}
  \renewcommand{\footrulewidth}{0pt}
}

\fancypagestyle{ucubody}{%
  \fancyhf{}
  \renewcommand{\headrulewidth}{0.6pt}
  \renewcommand{\headrule}{{\color{ucured}\hrule width\headwidth height\headrulewidth}}
  \renewcommand{\footrulewidth}{0pt}
  \fancyhead[L]{\sffamily\small\color{ucured}\ucu@courseline}%
  \fancyhead[R]{\sffamily\small\color{ucured}\ucu@pagelabel\ \thepage\ \ucu@oflabel\ \pageref{LastPage}}%
}

\newcommand{\maketitlepage}{%
  \ucu@checkrequired
  \thispagestyle{ucutitle}
  \begin{center}
  %% Явні \vspace керують усім вертикальним ритмом титулки; \parskip з
  %% основного тексту тут лише заважає (накопичується на кожному \par і
  %% зсуває вміст, аж до переповнення сторінки), тож на титулці він вимкнений.
  \setlength{\parskip}{0pt}%
  \vspace*{18mm}
  {\ucu@sc{\fontsize{15}{18}\selectfont\color{ucured}\ucu@uniname}}\par
  \vspace{10mm}
  {\ucu@sc{\fontsize{10.5}{13}\selectfont\ucu@superheader}}\par
  \vspace{4mm}
  {\color{black}\rule{\linewidth}{0.5pt}}\par
  \vspace{7mm}
  {\bfseries\fontsize{20}{25}\selectfont\ucu@title}\par
  \ifdefvoid{\ucu@tagline}{}{%
    \vspace{4mm}
    {\itshape\fontsize{10.5}{13}\selectfont\color{ucugray}\ucu@tagline}\par
  }%
  \vspace{5mm}
  {\color{black}\rule{\linewidth}{0.5pt}}\par
  \vspace{10mm}
  \noindent
  \begin{tabular}[t]{@{}>{\centering\arraybackslash}p{0.44\linewidth}@{\hspace{0.06\linewidth}}>{\centering\arraybackslash}p{0.44\linewidth}@{}}
  {\itshape\ucu@labelteam:}\par\smallskip
  \ucu@memberlist
  &
  \ifdefvoid{\ucu@mentor}{}{%
    {\itshape\ucu@labelmentor:}\par\smallskip
    \ucu@sc{\textbf{\color{ucured}\ucu@mentor}}\par\smallskip
  }%
  \ifdefvoid{\ucu@repo}{}{%
    {\itshape\ucu@labelrepo:}\par\smallskip
    {\small\url{\ucu@repo}}\par
  }%
  \end{tabular}\par
  \vspace{10mm}
  {\itshape\ucu@submittedline\par\ucu@courseline}\par
  \ifdefvoid{\ucu@inthe}{}{%
    \vspace{3mm}
    {\itshape\ucu@inthe}\par
  }%
  \vspace{3mm}
  {\color{ucured}\ucu@facultyname}\par
  \vfill
  \includegraphics[height=22mm]{\ucu@sealfile}%
  \hspace{8mm}%
  \includegraphics[height=18mm]{\ucu@facultylogofile}\par
  \vspace{6mm}
  \iftoggle{ucu@slogan}{\ucu@slogantext\par\vspace{4mm}}{}
  \ifdefvoid{\ucu@date}{}{\ucu@date\par}
  \vspace*{14mm}
  \end{center}
  \clearpage
  \setcounter{page}{1}
  \pagestyle{ucubody}
}

%% ------------------------------------------------------------------
%% Список джерел + перевірка обсягу основного тексту
%% Студент викликає \ucuprintbibliography замість \printbibliography —
%% це автоматично фіксує, на якій сторінці закінчився основний текст.
%% ------------------------------------------------------------------
\newcommand{\ucuprintbibliography}{%
  \label{UCU@mainend}%
  \clearpage
  \printbibliography[title=\ucu@biblabel]%
}

\AtEndDocument{%
  \ifcsname r@UCU@mainend\endcsname
    \ClassInfo{ucuproposal}{Кількість сторінок основного тексту: \getpagerefnumber{UCU@mainend}}%
    \ifnum\getpagerefnumber{UCU@mainend}>2
      \ClassWarningNoLine{ucuproposal}{WARNING: Основний текст перевищує 2 сторінки (зараз \getpagerefnumber{UCU@mainend}). Скоротіть текст}%
    \fi
  \else
    \ClassWarningNoLine{ucuproposal}{Не вдалося визначити обсяг основного тексту: викличте \string\ucuprintbibliography\space замість \string\printbibliography}%
  \fi
}

%% ------------------------------------------------------------------
%% Contribution statement
%% ------------------------------------------------------------------
\newcount\ucu@sumpercent
\def\ucu@stripPercent#1\%{#1}

%% Використовується під \section{Contribution statement} у main.tex —
%% власного заголовка не друкує, щоб уникнути дублювання з \section.
\newenvironment{contributions}{%
  \ucu@sumpercent=0
  \par\addvspace{0.4em}
  \begin{itemize}
}{%
  \end{itemize}
  \ifnum\ucu@sumpercent=100\else
    \ClassWarningNoLine{ucuproposal}{Сума відсотків у contributions дорівнює \the\ucu@sumpercent, а має дорівнювати 100. Перевірте розподіл}%
  \fi
}

\newcommand{\contribution}[3]{%
  \item \textbf{#1} --- #2: #3%
  \global\advance\ucu@sumpercent by \ucu@stripPercent#2\relax
}

\endinput
