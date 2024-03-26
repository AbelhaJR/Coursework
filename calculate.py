import ast
import model
import operator

def calculate(repository,formula):
  node = ast.parse(formula,mode="eval")
  return natural(repository,node)

def natural(repository,node):
  options = {
    ast.Expression: natural_expression,
    ast.Num:        natural_num,
    ast.Constant:   natural_constant,
    ast.Name:       natural_name,
    ast.UnaryOp:    natural_unaryop,
    ast.BinOp:      natural_binop,
  } 
  f = options.get(type(node))
  if f != None: return f(repository,node)
  else: return 0

def natural_expression(repository,node):
  return natural(repository,node.body)

def natural_num(repository,node):
  return node.n

def natural_constant(repository,node):
  return node.value

def natural_name(repository,node):
  cell = repository.lookup(node.id)
  if cell != None:
    return calculate(repository,cell.formula)
  else:
    return 0 

def natural_unaryop(repository,node):
  options = {
    ast.USub: operator.sub
  }
  n = natural(repository,node.operand)
  f = options.get(type(node.op))
  if f != None: return f(0,n)
  else: return 0

def natural_binop(repository,node):
  options = {
    ast.Add: operator.add,
    ast.Sub: operator.sub,
    ast.Mult: operator.mul,
    ast.Div: operator.truediv,
  }
  n1 = natural(repository,node.left)
  n2 = natural(repository,node.right)
  f  = options.get(type(node.op))
  if f != None: return f(n1,n2)
  else: return 0
