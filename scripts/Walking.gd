extends XROrigin3D

const curvature = 4.0
const curvatureGain = 1.0 / curvature
const maxCurvature = 1.0 / curvature
var lastPos = Vector3(0,0,0)
var centerPos = Vector3(0,0,0)

var lastTheta = 0
var thetaGain = 0.2

var applyCurvature = true
var applyRotation = true

# Called when the node enters the scene tree for the first time.
func _ready():
	var camera = %XRCamera3D
	lastPos = camera.position
	lastPos.y = 0
	lastTheta = camera.rotation.y
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	%Viewport2Din3D.position = %LeftController.global_position 
	%Viewport2Din3D.rotation = %LeftController.global_rotation
	%Viewport2Din3D.position += %LeftController.transform.basis.y * 0.2
	%Viewport2Din3D.position += %LeftController.transform.basis.x * -0.3
	
	var camera = %XRCamera3D
	#print(str(o.position))
	# Apply Curvature Gain
	# Amount user walked since last step
	var deltaPos = camera.position - lastPos
	deltaPos.y = 0
	if deltaPos.length() > 0:
		lastPos = camera.position
		lastPos.y = 0
		if applyCurvature:
			# Direction from user to center of room
			var toCenter = centerPos - camera.position
			toCenter.y = 0
			
			# Determine vector to modify movement
			var anglePositive = (toCenter.x * deltaPos.z - toCenter.z * deltaPos.x) > 0
			var costheta = (toCenter.dot(deltaPos)) / (toCenter.length() * deltaPos.length())
			var magnitudeCorrectionAngle = max(min(1 - costheta, 1), 0)
			var magnitudeCorrection = magnitudeCorrectionAngle * min(toCenter.length() / 1, 1)
			var rotAngle
			if anglePositive:
				#rotAngle = deltaPos.length() * curvatureGain * magnitudeCorrection
				rotAngle = -maxCurvature * magnitudeCorrection
			else:
				#rotAngle = -deltaPos.length() * curvatureGain * magnitudeCorrection
				rotAngle = maxCurvature * magnitudeCorrection
				
			# Apply transform to XROrigin location/orientation
			# Perform rotation of XROrigin around the camera
			self.translate(camera.position)
			var rotAmount = rotAngle * deltaPos.length()
			self.rotate(Vector3(0,1,0), rotAmount)
			self.translate(-camera.position)
	
	# Get rotation since last step
	var deltaTheta = camera.rotation.y - lastTheta
	# Cast between -PI, PI
	if deltaTheta > PI:
		deltaTheta -= 2 * PI
	elif deltaTheta < -PI:
		deltaTheta += 2 * PI
	if deltaTheta != 0:
		lastTheta = camera.rotation.y
		if applyRotation:
			# Determine if rotation is towards or away from center
			var toCenter = centerPos - camera.position
			toCenter.y = 0
			var lookDir = Vector3(cos(lastTheta), 0, sin(lastTheta))
			var anglePositive = (toCenter.x * lookDir.z - toCenter.z * lookDir.x) > 0
			var movingInwards = (anglePositive == deltaTheta > 0)
			
			# Determine how close currently to center
			var cosPhi = toCenter.dot(lookDir) / (toCenter.length()) # lookDir is unit vector
			var magnitudeCorrection = max(min(1 - cosPhi, 1), 0)
			
			self.translate(camera.position)
			var rotAmount = deltaTheta * thetaGain * magnitudeCorrection
			if movingInwards:
				self.rotate(Vector3(0,1,0), rotAmount)
			else:
				self.rotate(Vector3(0,1,0), -rotAmount)
			self.translate(-camera.position)
			
	return
