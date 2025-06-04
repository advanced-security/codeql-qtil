bindingset[result]
bindingset[s]
FluentString fluentString(string s) { result = s }

class FluentString extends string {
  bindingset[this]
  FluentString() { any() }

  bindingset[s, this]
  FluentString append(string s) { result = this + s }

  bindingset[s, this]
  FluentString prepend(string s) { result = s + this }
}
