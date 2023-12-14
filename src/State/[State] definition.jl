#----------------------------------------------
# State type
#     - State is application dependent
#     - Therefore only an abstact type can be defined to be subclassed

abstract type State end
abstract type Measure end

# will return the full state at the end of the sim
struct ValueMeasure <: Measure end       
struct ObjectMeasure <: Measure end

const StateMeasure  = ObjectMeasure
const RecordMeasure = ObjectMeasure
