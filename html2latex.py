import re
def html2latex(instr):
    instr = instr.replace('<br />', '\\newline ')
    instr = re.sub('<p[^>]*>', '', instr).replace('</p>', '\\par\n')
    instr = instr.replace('<li>', '\\item ').replace('</li>', '')
    instr = instr.replace('<ol>', '\\begin{enumerate}').replace('</ol>', '\\end{enumerate}')
    instr = instr.replace('<ul>', '\\begin{itemize}').replace('</ul>', '\\end{itemize}')
    instr = instr.replace('<sub>', '\\textsubscript{').replace('</sub>', '}')
    instr = instr.replace('<sup>', '\\textsuperscript{').replace('</sup>', '}')
    instr = instr.replace('<blockquote>', '\\begin{quote}').replace('</blockquote>', '\\end{quote}')
    instr = instr.replace('<em>', '{\\em ').replace('</em>', '}')
    instr = instr.replace('<strong>', '{\\bfseries ').replace('</strong>', '}')
    instr = instr.replace(' &', '\&')
    instr = instr.replace('Γ', '\\ensuremath\\Gamma ')
    instr = instr.replace('Ω', '\\ensuremath\\Omega ')
    instr = instr.replace('∑', '\\ensuremath\\Sigma ')
    instr = instr.replace('∇', '\\ensuremath\\Delta ')
    instr = instr.replace('λ', '\\ensuremath\\lambda ')
    instr = instr.replace('φ', '\\ensuremath\\varphi ')
    instr = instr.replace('ψ', '\\ensuremath\\psi ')
    instr = instr.replace('ξ', '\\ensuremath\\xi ')
    instr = instr.replace('β', '\\ensuremath\\beta ')
    instr = instr.replace('θ', '\\ensuremath\\Theta ')
    instr = instr.replace('\R', '\\mathbb{R}')
    instr = instr.replace(u'\u2003', '~')
    instr = instr.replace(u'\u202F', '~')
    instr = instr.replace(u'\u2248', '')
    instr = instr.replace(u'\u0301', '\\\'')
    return  instr
