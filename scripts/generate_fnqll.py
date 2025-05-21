from jinja2 import Environment, FileSystemLoader
import os

env = Environment(loader=FileSystemLoader('scripts/templates'))
env.trim_blocks = True
env.lstrip_blocks = True
output_dir = 'src/qtil/fn/generated'

def arity_to_string(i):
    if i == 0:
        return "Nullary"
    elif i == 1:
        return "Unary"
    elif i == 2:
        return "Binary"
    elif i == 3:
        return "Ternary"
    elif i == 4:
        return "Quaternary"
    elif i == 5:
        return "Quinary"
    elif i == 6:
        return "Senary"
    elif i == 7:
        return "Septenary"
    else:
        raise ValueError("Invalid arity")

kinds = ["Fn", "Rel", "Prop", "Tp"]
param_types = ["A", "B", "C", "D", "E", "F", "G"]
nth = ["first", "second", "third", "fourth", "fifth", "sixth"]
kindnames = {
    "Fn": "Function",
    "Rel": "Relation",
    "Prop": "Property",
    "Tp": "Tuple predicate"
}
max_arity = 6

def get_nths(arity):
    result = []

    def lodash_get_as_i(i):
        return lambda name: ', '.join(map(
            lambda j: name if j == i else '_',
            range(0, arity)
        ))

    for i in range(0, arity):
        param_type = param_types[i]
        result.append({
            'idx': i,
            'name': nth[i],
            'type': param_type,
            'varname': param_type.lower(),
            'lodash_get_as': lodash_get_as_i(i),
        })
    return result

def get_type_params(arity, suffix=''):
    result = []
    for i in range(0, arity):
        name = param_types[i] + suffix
        result.append({
            'name': name,
            'typedecl': 'InfiniteStringableType ' + name,
            'vardecl': f'{name} {name.lower()}',
            'varname': name.lower(),
            'vardecl2': f'{name} {name.lower()}0',
            'varname2': f'{name.lower()}0',
            '_': '_',
            'idx': i,
        })
    return result

def write_out(filename, contents):
    print(f"Generating {filename}...")
    path = os.path.join(output_dir, filename)
    # Write to file
    with open(path, 'w') as f:
        f.write(contents)
    # Format the file
    os.system(f"codeql query format -i {path}")

def generate_types_qll():
    template = env.get_template('Types.qll.j2')
    config = {'modules': [
        {
            'kind': kind,
            'kindname': kindnames[kind],
            'arity': arity,
            'n_ary': arity_to_string(arity),
            'has_return': kind == 'Fn' or kind == 'Rel',
            'unbound_params': kind == 'Fn' or kind == 'Prop',
            'types': get_type_params(arity)
        } for kind in kinds for arity in range(0, max_arity + 2)
            # Exclude Rel0, Tp0, and Prop0, but keep Fn0.
            if arity != 0 or kind == 'Fn'
        ]
    }

    write_out('Types.qll', template.render(config))

def generate_tuple_get_qll():
    template = env.get_template('TupleGet.qll.j2')
    modules = []

    for arity in range(1, max_arity + 1):
        modules.append({
            'arity': arity,
            'types': get_type_params(arity),
            'nths': get_nths(arity),
        })

    config = {
        'modules': modules,
    }
    
    write_out('TupleGet.qll', template.render(config))

def generate_ordering_qll():
    template = env.get_template('Ordering.qll.j2')
    modules = []

    for arity in range(1, max_arity + 1):
        modules.append({
            'arity': arity,
            'types': get_type_params(arity),
        })

    config = {
        'modules': modules,
    }
    
    write_out('Ordering.qll', template.render(config))

def generate_ordered_tp_qll():
    template = env.get_template('OrderedTp.qll.j2')
    modules = []

    for arity in range(1, max_arity + 1):
        modules.append({
            'arity': arity,
            'types': get_type_params(arity),
        })

    config = {
        'modules': modules,
    }
    
    write_out('OrderedTp.qll', template.render(config))

def generate_tp_qll():
    template = env.get_template('Tp.qll.j2')
    modules = []
    arities = [{}]

    for arity in range(1, max_arity + 1):
        modules.append({
            'arity': arity,
            'n_ary': arity_to_string(arity),
            'types': get_type_params(arity),
            'nths': get_nths(arity),
        })
        arities.append(get_type_params(arity, '0'))

    config = {
        'modules': modules,
        'arities': arities,
        'max_arity': max_arity,
    }
    
    write_out('Tp.qll', template.render(config))

def generate_fn_qll():
    template = env.get_template('Fn.qll.j2')
    modules = []
    arities = [{}]

    for arity in range(0, max_arity + 1):
        ptypes = get_type_params(arity)
        rtype = {
            'name': 'R',
            'typedecl': 'InfiniteStringableType R',
            'vardecl': 'R r',
            'varname': 'r',
            'vardecl2': 'R r0',
            'varname2': 'r0',
        }

        modules.append({
            'arity': arity,
            'n_ary': arity_to_string(arity),
            'ptypes': ptypes,
            'rtype': rtype,
            'types': [rtype] + ptypes,
            'nths': get_nths(arity),
        })
        arities.append(get_type_params(arity, '0'))

    config = {
        'modules': modules,
        'arities': arities,
        'max_arity': max_arity,
    }
    
    write_out('Fn.qll', template.render(config))

def generate_prop_qll():
    template = env.get_template('Prop.qll.j2')
    modules = []

    for arity in range(1, max_arity + 1):
        modules.append({
            'arity': arity,
            'types': get_type_params(arity),
        })

    config = {
        'modules': modules,
    }
    
    write_out('Prop.qll', template.render(config))

generate_prop_qll()
generate_fn_qll()
generate_types_qll()
generate_tuple_get_qll()
generate_ordering_qll()
generate_ordered_tp_qll()
generate_tp_qll()