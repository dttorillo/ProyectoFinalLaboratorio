// Algoritmo Principal: Sistema de Gestión Universitaria

Algoritmo Universidad
	// "Base de datos"
	Dimension materias[10], alumnos[10], profesores[10], materiaProfesor[10]
	Dimension inscripciones[10,10], notas[10,10]
	Dimension usuarios[30], contraseñas[30], roles[30] // roles: 1=Admin,2=Profesor,3=Alumno
	Dimension intentosFallidos[30], estadoUsuario[30], debeCambiarPass[30]
	Dimension alumnoUsuarioId[10], profesorUsuarioId[10]
	Dimension cupoMateria[10]  // capacidad por materia
	
	// Contadores generales del sistema
	Definir totalMaterias, totalAlumnos, totalProfesores, totalUsuarios Como Entero
	
	// Cargamos los datos iniciales
	InicializarDatos(materias, totalMaterias, usuarios, contraseñas, roles, totalUsuarios, intentosFallidos, estadoUsuario, debeCambiarPass, alumnos, profesores, totalAlumnos, totalProfesores, alumnoUsuarioId, profesorUsuarioId, cupoMateria, inscripciones, notas, materiaProfesor)
	
	// Bucle principal
	Definir rolActual, idUsuarioActual Como Entero
	Definir salirPrograma Como Logico
	salirPrograma <- Falso
	
	Repetir
		Login(usuarios, contraseñas, roles, totalUsuarios, intentosFallidos, estadoUsuario, idUsuarioActual, rolActual, salirPrograma, debeCambiarPass)
		
		Si NO salirPrograma Entonces
			Segun rolActual Hacer
				1:
					MenuAdministrador(materias, alumnos, profesores, materiaProfesor, inscripciones, notas, usuarios, contraseñas, roles, totalMaterias, totalAlumnos, totalProfesores, totalUsuarios, intentosFallidos, estadoUsuario, alumnoUsuarioId, profesorUsuarioId, cupoMateria, debeCambiarPass)
				2:
					MenuProfesor(materias, alumnos, profesores, materiaProfesor, notas, inscripciones, totalMaterias, totalAlumnos, totalProfesores, idUsuarioActual, usuarios, contraseñas, totalUsuarios, debeCambiarPass)
				3:
					MenuAlumno(materias, alumnos, notas, inscripciones, totalMaterias, totalAlumnos, idUsuarioActual, usuarios, contraseñas, totalUsuarios, cupoMateria, debeCambiarPass, alumnoUsuarioId)
			FinSegun
		FinSi
	Hasta Que salirPrograma
	
	Escribir "Programa finalizado."
FinAlgoritmo

// ======================= MÓDULOS DEL SISTEMA =======================

// Inicializa variables, usuarios predefinidos, arreglos y vínculos
SubProceso InicializarDatos(materias Por Referencia, totalMaterias Por Referencia, usuarios Por Referencia, contraseñas Por Referencia, roles Por Referencia, totalUsuarios Por Referencia, intentosFallidos Por Referencia, estadoUsuario Por Referencia, debeCambiarPass Por Referencia, alumnos Por Referencia, profesores Por Referencia, totalAlumnos Por Referencia, totalProfesores Por Referencia, alumnoUsuarioId Por Referencia, profesorUsuarioId Por Referencia, cupoMateria Por Referencia, inscripciones Por Referencia, notas Por Referencia, materiaProfesor Por Referencia)
	// Contadores
	totalUsuarios <- 3
	totalMaterias <- 3
	totalAlumnos <- 0
	totalProfesores <- 0
	
	// Limpiar mapeo de id/usuario
	Para i <- 1 Hasta 10 Hacer
		alumnoUsuarioId[i] <- 0
		profesorUsuarioId[i] <- 0
	FinPara
	
	// Materias base + cupos
	materias[1] <- "Programacion"
	materias[2] <- "Matematica"
	materias[3] <- "Algoritmos"
	cupoMateria[1] <- 30
	cupoMateria[2] <- 40
	cupoMateria[3] <- 35
	
	// Usuarios base
	usuarios[1] <- "admin"
	contraseñas[1] <- "1234"
	roles[1] <- 1
	usuarios[2] <- "prof"
	contraseñas[2] <- "1234"
	roles[2] <- 2
	usuarios[3] <- "alum"
	contraseñas[3] <- "1234"
	roles[3] <- 3
	
	// Estados seteados en activo
	Para i <- 1 Hasta 30 Hacer
		intentosFallidos[i] <- 0
		estadoUsuario[i] <- 1 // 1 = Activo, 0 = Bloqueado
		debeCambiarPass[i] <- 0
	FinPara
	
	// Inicialización segura de arreglos 2D y 1D
	Para i <- 1 Hasta 10 Hacer
		materiaProfesor[i] <- 0
		Si cupoMateria[i] = 0 Entonces
			cupoMateria[i] <- 30
		FinSi
		Para j <- 1 Hasta 10 Hacer
			inscripciones[i,j] <- 0
			notas[i,j] <- 0
		FinPara
	FinPara
	
	// vincular usuarios base
	Si roles[2] = 2 Entonces
		totalProfesores <- totalProfesores + 1
		profesores[totalProfesores] <- usuarios[2]   // "prof"
		profesorUsuarioId[totalProfesores] <- 2
	FinSi
	
	Si roles[3] = 3 Entonces
		totalAlumnos <- totalAlumnos + 1
		alumnos[totalAlumnos] <- usuarios[3]         // "alum"
		alumnoUsuarioId[totalAlumnos] <- 3
	FinSi
FinSubProceso

// Módulo de Login: valida usuario, controla intentos y fuerza cambio de contraseña
SubProceso Login(usuarios, contraseñas, roles, totalUsuarios, intentosFallidos Por Referencia, estadoUsuario Por Referencia, idUsuarioActual Por Referencia, rolActual Por Referencia, salir Por Referencia, debeCambiarPass Por Referencia)
	Definir user, pass Como Cadena
	Definir encontrado Como Logico
	Definir id_temporal Como Entero
	encontrado <- Falso
	
	Repetir
		Escribir "--- INICIO DE SESIÓN ---"
		Escribir "Usuario (0 para salir):"
		Leer user
		
		Si user = "0" Entonces
			salir <- Verdadero
		SiNo
			id_temporal <- BuscarIdUsuario(usuarios, totalUsuarios, user)
			
			Si id_temporal = 0 Entonces
				Escribir "Usuario no existe."
				Escribir "Presione una tecla para continuar..."
				Esperar Tecla
			SiNo
				Si estadoUsuario[id_temporal] = 0 Entonces
					Escribir "ACCESO DENEGADO: El usuario está bloqueado."
					Escribir "Presione una tecla para continuar..."
					Esperar Tecla
				SiNo
					Escribir "Contraseña:"
					Leer pass
					
					Si contraseñas[id_temporal] = pass Entonces
						Escribir "¡Bienvenido!"
						encontrado <- Verdadero
						rolActual <- roles[id_temporal]
						idUsuarioActual <- id_temporal
						intentosFallidos[id_temporal] <- 0
						
						Si debeCambiarPass[id_temporal] = 1 Entonces
							Escribir "Debes cambiar tu contraseña antes de continuar."
							CambiarPassword(contraseñas, idUsuarioActual, debeCambiarPass)
						FinSi
					SiNo
						intentosFallidos[id_temporal] <- intentosFallidos[id_temporal] + 1
						Escribir "Contraseña incorrecta. Intento ", intentosFallidos[id_temporal], " de 3."
						Si intentosFallidos[id_temporal] >= 3 Entonces
							estadoUsuario[id_temporal] <- 0
							Escribir "Ha superado el límite de intentos. El usuario ha sido bloqueado."
						FinSi
						Escribir "Presione una tecla para continuar..."
						Esperar Tecla
					FinSi
				FinSi
			FinSi
		FinSi
	Hasta Que encontrado O salir
	Limpiar Pantalla
FinSubProceso

// ======================= ADMINISTRADOR =======================
SubProceso MenuAdministrador(materias Por Referencia, alumnos Por Referencia, profesores Por Referencia, materiaProfesor Por Referencia, inscripciones Por Referencia, notas Por Referencia, usuarios Por Referencia, contraseñas Por Referencia, roles Por Referencia, totalMaterias Por Referencia, totalAlumnos Por Referencia, totalProfesores Por Referencia, totalUsuarios Por Referencia, intentosFallidos Por Referencia, estadoUsuario Por Referencia, alumnoUsuarioId Por Referencia, profesorUsuarioId Por Referencia, cupoMateria Por Referencia, debeCambiarPass Por Referencia)
	Definir op, opcionModificar, idModificar, id_existente, idMateria, idProfesor Como Entero
	Definir nuevoNombre, nuevaMateria, nuevoAlumno, nuevoProfesor, pass, conf Como Cadena
	Definir i, j, cont, maxCant, idTop Como Entero
	Definir tiene, ninguno Como Logico
	
	Repetir
		Escribir "=== Menu Administrador ==="
		Escribir "1. Crear materia"
		Escribir "2. Crear alumno"
		Escribir "3. Crear profesor"
		Escribir "4. Asignar profesor a materia"
		Escribir "5. Modificar Datos (alumno/materia)"
		Escribir "6. Ver estadisticas (ampliadas)"
		Escribir "7. Gestionar Usuarios (bloq/desbloq)"
		Escribir "8. Eliminar registros (materia/alumno/profesor)"
		Escribir "9. Salir"
		Leer op
		Limpiar Pantalla
		
		Segun op Hacer
			1: // Crear Materia
				Si totalMaterias < 10 Entonces
					Escribir "Ingrese el nombre de la nueva materia:"
					Leer nuevaMateria
					totalMaterias <- totalMaterias + 1
					materias[totalMaterias] <- nuevaMateria
					Escribir "Defina el cupo máximo:"
					Leer cupoMateria[totalMaterias]
					Escribir "¡Materia ", nuevaMateria, " creada con éxito!"
				SiNo
					Escribir "No se pueden agregar mas materias."
				FinSi
				Escribir "Presione una tecla para continuar..."
				Esperar Tecla
				
			2: // Crear Alumno
				Si totalAlumnos < 10 Entonces
					Escribir "Ingrese el nombre del nuevo alumno (será su usuario):"
					Leer nuevoAlumno
					
					id_existente <- BuscarIdUsuario(usuarios, totalUsuarios, nuevoAlumno)
					
					Si id_existente <> 0 Entonces
						Escribir "Error: El nombre de usuario ", nuevoAlumno, " ya existe."
					SiNo
						totalAlumnos <- totalAlumnos + 1
						alumnos[totalAlumnos] <- nuevoAlumno
						totalUsuarios <- totalUsuarios + 1
						usuarios[totalUsuarios] <- nuevoAlumno
						Escribir "Defina contraseña temporal para ", nuevoAlumno, ":"
						Leer pass
						contraseñas[totalUsuarios] <- pass
						roles[totalUsuarios] <- 3
						debeCambiarPass[totalUsuarios] <- 1
						alumnoUsuarioId[totalAlumnos] <- totalUsuarios
						Escribir "Alumno creado con éxito (debe cambiar la contraseña al ingresar)."
					FinSi
				SiNo
					Escribir "No se pueden agregar más alumnos."
				FinSi
				Escribir "Presione una tecla para continuar..."
				Esperar Tecla
				
			3: // Crear Profesor
				Si totalProfesores < 10 Entonces
					Escribir "Ingrese el nombre del nuevo profesor (será su usuario):"
					Leer nuevoProfesor
					
					id_existente <- BuscarIdUsuario(usuarios, totalUsuarios, nuevoProfesor)
					
					Si id_existente <> 0 Entonces
						Escribir "Error: El nombre de usuario ", nuevoProfesor, " ya existe."
					SiNo
						totalProfesores <- totalProfesores + 1
						profesores[totalProfesores] <- nuevoProfesor
						totalUsuarios <- totalUsuarios + 1
						usuarios[totalUsuarios] <- nuevoProfesor
						Escribir "Defina contraseña temporal para ", nuevoProfesor, ":"
						Leer pass
						contraseñas[totalUsuarios] <- pass
						roles[totalUsuarios] <- 2
						debeCambiarPass[totalUsuarios] <- 1
						profesorUsuarioId[totalProfesores] <- totalUsuarios
						Escribir "Profesor creado con éxito (debe cambiar la contraseña al ingresar)."
					FinSi
				SiNo
					Escribir "No se pueden agregar más profesores."
				FinSi
				Escribir "Presione una tecla para continuar..."
				Esperar Tecla
				
			4: // Asignar Materia
				Si totalMaterias > 0 Y totalProfesores > 0 Entonces
					Escribir "Seleccione la materia:"
					Para i<-1 Hasta totalMaterias Hacer
						Escribir i, ". ", materias[i]
					FinPara
					Leer idMateria
					Si idMateria < 1 O idMateria > totalMaterias Entonces
						Escribir "Opción no válida."
					SiNo
						Escribir "Seleccione el profesor:"
						Para i<-1 Hasta totalProfesores Hacer
							Escribir i, ". ", profesores[i]
						FinPara
						Leer idProfesor
						Si idProfesor < 1 O idProfesor > totalProfesores Entonces
							Escribir "Opción no válida."
						SiNo
							materiaProfesor[idMateria] <- idProfesor
							Escribir "Profesor asignado."
						FinSi
					FinSi
				SiNo
					Escribir "Debe crear materias y profesores primero."
				FinSi
				Escribir "Presione una tecla para continuar..."
				Esperar Tecla
				
			5: // Modificar Datos
				Repetir
					Escribir "--- Submenú Modificar ---"
					Escribir "1. Cambiar nombre de Alumno (sincroniza usuario)"
					Escribir "2. Cambiar nombre de Materia"
					Escribir "3. Volver"
					Leer opcionModificar
					Segun opcionModificar Hacer
						1:
							Si totalAlumnos = 0 Entonces
								Escribir "No hay alumnos cargados."
							SiNo
								Escribir "Seleccione el alumno a modificar:"
								Para i<-1 Hasta totalAlumnos Hacer
									Escribir i, ". ", alumnos[i]
								FinPara
								Leer idModificar
								Si idModificar>=1 y idModificar<=totalAlumnos Entonces
									Escribir "Ingrese el nuevo nombre para ", alumnos[idModificar], ":"
									Leer nuevoNombre
									usuarios[ alumnoUsuarioId[idModificar] ] <- nuevoNombre
									alumnos[idModificar] <- nuevoNombre
									Escribir "Nombre de alumno y usuario actualizado."
								SiNo
									Escribir "Opción no válida."
								FinSi
							FinSi
						2:
							Si totalMaterias = 0 Entonces
								Escribir "No hay materias cargadas."
							SiNo
								Escribir "Seleccione la materia a modificar:"
								Para i<-1 Hasta totalMaterias Hacer
									Escribir i, ". ", materias[i]
								FinPara
								Leer idModificar
								Si idModificar>=1 y idModificar<=totalMaterias Entonces
									Escribir "Ingrese el nuevo nombre para ", materias[idModificar], ":"
									Leer nuevoNombre
									materias[idModificar] <- nuevoNombre
									Escribir "Nombre actualizado."
								SiNo
									Escribir "Opción no válida."
								FinSi
							FinSi
					FinSegun
					Si opcionModificar <> 3 Entonces
						Escribir "Presione una tecla para continuar..."
						Esperar Tecla
					FinSi
				Hasta Que opcionModificar = 3
				
			6: // Estadísticas ampliadas
				Escribir "=== Estadisticas ==="
				Para j<-1 Hasta totalMaterias Hacer
					cont <- 0
					Para i<-1 Hasta totalAlumnos Hacer
						Si inscripciones[i,j] = 1 Entonces
							cont <- cont + 1
						FinSi
					FinPara
					Escribir materias[j], ": ", cont, " alumnos (cupo ", cupoMateria[j], ")."
				FinPara
				
				maxCant <- -1
				idTop <- 0
				Para j<-1 Hasta totalMaterias Hacer
					cont <- 0
					Para i<-1 Hasta totalAlumnos Hacer
						Si inscripciones[i,j] = 1 Entonces
							cont <- cont + 1
						FinSi
					FinPara
					Si cont > maxCant Entonces
						maxCant <- cont
						idTop <- j
					FinSi
				FinPara
				Si idTop > 0 Entonces
					Escribir "Materia con más inscriptos: ", materias[idTop], " (", maxCant, ")"
				FinSi
				
				Escribir "Alumnos sin inscripción:"
				ninguno <- Verdadero
				Para i<-1 Hasta totalAlumnos Hacer
					tiene <- Falso
					Para j<-1 Hasta totalMaterias Hacer
						Si inscripciones[i,j] = 1 Entonces
							tiene <- Verdadero
						FinSi
					FinPara
					Si NO tiene Entonces
						Escribir "- ", alumnos[i]
						ninguno <- Falso
					FinSi
				FinPara
				Si ninguno Entonces
					Escribir "(Todos tienen al menos una inscripción)"
				FinSi
				Escribir "Presione una tecla para continuar..."
				Esperar Tecla
				
			7: // Bloquear / Desbloquear usuarios
				Escribir "--- Gestión de Usuarios ---"
				Para i <- 1 Hasta totalUsuarios Hacer
					Escribir Sin Saltar, i, ". ", usuarios[i]
					Si estadoUsuario[i] = 1 Entonces
						Escribir " (Activo)"
					SiNo
						Escribir " (Bloqueado)"
					FinSi
				FinPara
				Escribir "Seleccione un usuario para cambiar su estado (0 para cancelar):"
				Leer idModificar
				Si idModificar > 0 Y idModificar <= totalUsuarios Entonces
					Si estadoUsuario[idModificar] = 1 Entonces
						estadoUsuario[idModificar] <- 0
						Escribir "Usuario ", usuarios[idModificar], " ha sido BLOQUEADO."
					SiNo
						estadoUsuario[idModificar] <- 1
						intentosFallidos[idModificar] <- 0
						Escribir "Usuario ", usuarios[idModificar], " ha sido DESBLOQUEADO."
					FinSi
				FinSi
				Escribir "Presione una tecla para continuar..."
				Esperar Tecla
				
			8: // Eliminar registros
				Escribir "--- Eliminar ---"
				Escribir "1. Eliminar Materia"
				Escribir "2. Eliminar Alumno"
				Escribir "3. Eliminar Profesor"
				Escribir "4. Volver"
				Leer opcionModificar
				
				Segun opcionModificar Hacer
					1:
						Si totalMaterias = 0 Entonces
							Escribir "No hay materias cargadas."
						SiNo
							Escribir "Seleccione materia:"
							Para i<-1 Hasta totalMaterias Hacer
								Escribir i, ". ", materias[i]
							FinPara
							Leer idMateria
							Si idMateria>=1 Y idMateria<=totalMaterias Entonces
								Escribir "¿Seguro? (S/N)"
								Leer conf
								Si conf="S" O conf="s" Entonces
									EliminarMateria(materias, totalMaterias, idMateria, inscripciones, notas, materiaProfesor, totalAlumnos, cupoMateria)
								SiNo
									Escribir "Operación cancelada."
								FinSi
							SiNo
								Escribir "Opción inválida."
							FinSi
						FinSi
						Escribir "Presione una tecla para continuar..."
						Esperar Tecla
						
					2:
						Si totalAlumnos = 0 Entonces
							Escribir "No hay alumnos cargados."
						SiNo
							Escribir "Seleccione alumno:"
							Para i<-1 Hasta totalAlumnos Hacer
								Escribir i, ". ", alumnos[i]
							FinPara
							Leer idModificar
							Si idModificar < 1 O idModificar > totalAlumnos Entonces
								Escribir "Opción inválida."
							SiNo
								Escribir "¿Seguro? (S/N)"
								Leer conf
								Si conf="S" O conf="s" Entonces
									EliminarAlumno(alumnos, totalAlumnos, idModificar, inscripciones, notas, totalMaterias, usuarios, totalUsuarios, alumnoUsuarioId, roles, contraseñas, estadoUsuario, intentosFallidos, debeCambiarPass)
								SiNo
									Escribir "Operación cancelada."
								FinSi
							FinSi
						FinSi
						Escribir "Presione una tecla para continuar..."
						Esperar Tecla
						
					3:
						Si totalProfesores = 0 Entonces
							Escribir "No hay profesores cargados."
						SiNo
							Escribir "Seleccione profesor:"
							Para i<-1 Hasta totalProfesores Hacer
								Escribir i, ". ", profesores[i]
							FinPara
							Leer idModificar
							Si idModificar>=1 Y idModificar<=totalProfesores Entonces
								Escribir "¿Seguro? (S/N)"
								Leer conf
								Si conf="S" O conf="s" Entonces
									EliminarProfesor(profesores, totalProfesores, idModificar, materiaProfesor, totalMaterias, usuarios, totalUsuarios, profesorUsuarioId, roles, contraseñas, estadoUsuario, intentosFallidos, debeCambiarPass)
								SiNo
									Escribir "Operación cancelada."
								FinSi
							SiNo
								Escribir "Opción inválida."
							FinSi
						FinSi
						Escribir "Presione una tecla para continuar..."
						Esperar Tecla
				FinSegun
				
			9:
				Escribir "Cerrando sesión de administrador..."
				
			De Otro Modo:
				Escribir "Opción no válida."
				Escribir "Presione una tecla para continuar..."
				Esperar Tecla
		FinSegun
	Hasta Que op = 9
FinSubProceso

// ======================= PROFESOR =======================
SubProceso MenuProfesor(materias, alumnos, profesores, materiaProfesor, notas Por Referencia, inscripciones, totalMaterias, totalAlumnos, totalProfesores, idUsuarioLogueado, usuarios, contraseñas Por Referencia, totalUsuarios, debeCambiarPass Por Referencia)
	Definir op, i, cont, opcionMateria, idMateria, nota, cant, idProfesorLocal Como Entero
	Definir suma, promedio Como Real
	Dimension listaMaterias[10]
	
	idProfesorLocal <- BuscarIdUsuario(profesores, totalProfesores, usuarios[idUsuarioLogueado])
	
	Repetir
		Escribir "=== Menu Profesor - ", usuarios[idUsuarioLogueado], " ==="
		Escribir "1. Cargar notas"
		Escribir "2. Ver mis materias (con promedios)"
		Escribir "3. Cambiar Contraseña"
		Escribir "4. Salir"
		Leer op
		Limpiar Pantalla
		
		Si idProfesorLocal > 0 Entonces
			Segun op Hacer
				1: // Cargar Notas
					cont <- 0
					Para i <- 1 Hasta totalMaterias Hacer
						Si materiaProfesor[i] = idProfesorLocal Entonces
							cont <- cont + 1
							listaMaterias[cont] <- i
						FinSi
					FinPara
					Si cont = 0 Entonces
						Escribir "No tiene materias asignadas."
					SiNo
						Escribir "Seleccione materia para cargar notas:"
						Para i <- 1 Hasta cont Hacer
							Escribir i, ". ", materias[listaMaterias[i]]
						FinPara
						Leer opcionMateria
						Si opcionMateria<1 O opcionMateria>cont Entonces
							Escribir "Opción inválida."
						SiNo
							idMateria <- listaMaterias[opcionMateria]
							Escribir "Alumnos inscriptos en ", materias[idMateria], ":"
							Para i <- 1 Hasta totalAlumnos Hacer
								Si inscripciones[i,idMateria] = 1 Entonces
									Repetir
										Escribir "Ingrese nota (0 a 10) para ", alumnos[i], ":"
										Leer nota
									Hasta Que nota>=0 Y nota<=10
									notas[i,idMateria] <- nota
								FinSi
							FinPara
							Escribir "Notas cargadas."
						FinSi
					FinSi
					
				2: // Ver Materias y Promedios
					cont <- 0
					Para i <- 1 Hasta totalMaterias Hacer
						Si materiaProfesor[i] = idProfesorLocal Entonces
							cont <- cont + 1
							listaMaterias[cont] <- i
						FinSi
					FinPara
					Si cont = 0 Entonces
						Escribir "No tiene materias asignadas."
					SiNo
						Escribir "Seleccione materia para ver alumnos:"
						Para i <- 1 Hasta cont Hacer
							Escribir i, ". ", materias[listaMaterias[i]]
						FinPara
						Leer opcionMateria
						Si opcionMateria<1 O opcionMateria>cont Entonces
							Escribir "Opción inválida."
						SiNo
							idMateria <- listaMaterias[opcionMateria]
							Escribir "--- Alumnos en ", materias[idMateria], " ---"
							suma <- 0
							cant <- 0
							Para i <- 1 Hasta totalAlumnos Hacer
								Si inscripciones[i,idMateria] = 1 Entonces
									Escribir Sin Saltar " - ", alumnos[i], " - Nota: "
									Si notas[i,idMateria] <> 0 Entonces
										Escribir notas[i,idMateria]
										suma <- suma + notas[i,idMateria]
										cant <- cant + 1
									SiNo
										Escribir "(sin nota)"
									FinSi
								FinSi
							FinPara
							Si cant > 0 Entonces
								promedio <- suma / cant
								Escribir "---------------------------------"
								Escribir "Promedio de la materia: ", promedio
								Escribir "---------------------------------"
							SiNo
								Escribir "No hay alumnos con notas cargadas."
							FinSi
						FinSi
					FinSi
					
				3: // Cambiar Contraseña
					CambiarPassword(contraseñas, idUsuarioLogueado, debeCambiarPass)
					
				4:
					Escribir "Cerrando sesión de profesor..."
			FinSegun
		SiNo
			Escribir "Cerrando sesión de profesor..."
			op <- 4
		FinSi
		
		Si op <> 4 Entonces
			Escribir "Presione una tecla para continuar..."
			Esperar Tecla
		FinSi
		
	Hasta Que op = 4
FinSubProceso

// ======================= ALUMNO =======================
SubProceso MenuAlumno(materias, alumnos, notas, inscripciones Por Referencia, totalMaterias, totalAlumnos Por Referencia, idUsuarioLogueado, usuarios, contraseñas Por Referencia, totalUsuarios, cupoMateria, debeCambiarPass Por Referencia, alumnoUsuarioId Por Referencia)
	Definir op, i, j, idMateria, cant, cont Como Entero
	Definir suma, promedio Como Real
	Definir idAlumnoLocal Como Entero
	Definir hay Como Logico
	
	idAlumnoLocal <- BuscarIdUsuario(alumnos, totalAlumnos, usuarios[idUsuarioLogueado])
	
	Repetir
		Escribir "=== Menu Estudiante - ", usuarios[idUsuarioLogueado]," ==="
		Escribir "1. Inscribirse en materia"
		Escribir "2. Ver mis notas y promedio"
		Escribir "3. Cambiar Contraseña"
		Escribir "4. Desinscribirse de materia"
		Escribir "5. Salir"
		Leer op
		Limpiar Pantalla
		
		Si idAlumnoLocal > 0 Entonces
			Segun op Hacer
				1: // Inscribirse en materia
					Si totalMaterias = 0 Entonces
						Escribir "No hay materias disponibles."
					SiNo
						Escribir "Materias disponibles:"
						Para i<-1 Hasta totalMaterias Hacer
							Escribir i, ". ", materias[i]
						FinPara
						Escribir "Seleccione materia para inscribirse:"
						Leer idMateria
						Si idMateria<1 O idMateria>totalMaterias Entonces
							Escribir "Opción inválida."
						SiNo
							Si inscripciones[idAlumnoLocal, idMateria] = 1 Entonces
								Escribir "Ya estás inscripto en esa materia."
							SiNo
								cont <- 0
								Para i<-1 Hasta totalAlumnos Hacer
									Si inscripciones[i,idMateria] = 1 Entonces
										cont <- cont + 1
									FinSi
								FinPara
								Si cont >= cupoMateria[idMateria] Entonces
									Escribir "Cupo completo. No se puede inscribir."
								SiNo
									inscripciones[idAlumnoLocal, idMateria] <- 1
									Escribir "Inscripción exitosa."
								FinSi
							FinSi
						FinSi
					FinSi
					
				2: // Ver mis notas y promedio
					Escribir "--- Tus Notas ---"
					suma <- 0
					cant <- 0
					Para j<-1 Hasta totalMaterias Hacer
						Si inscripciones[idAlumnoLocal,j] = 1 Entonces
							Escribir materias[j], ": "
							Si notas[idAlumnoLocal,j] <> 0 Entonces
								Escribir "   Nota: ", notas[idAlumnoLocal,j]
								suma <- suma + notas[idAlumnoLocal,j]
								cant <- cant + 1
							SiNo
								Escribir "   (sin nota cargada)"
							FinSi
						FinSi
					FinPara
					Si cant > 0 Entonces
						promedio <- suma / cant
						Escribir "---------------------------------"
						Escribir "Tu promedio general: ", promedio
						Escribir "---------------------------------"
					SiNo
						Escribir "Aún no tienes notas cargadas."
					FinSi
					
				3: // Cambiar Contraseña
					CambiarPassword(contraseñas, idUsuarioLogueado, debeCambiarPass)
					
				4: // Desinscribirse
					Escribir "Materias en las que estás inscripto:"
					hay <- Falso
					Para j<-1 Hasta totalMaterias Hacer
						Si inscripciones[idAlumnoLocal,j] = 1 Entonces
							Escribir j, ". ", materias[j]
							hay <- Verdadero
						FinSi
					FinPara
					Si NO hay Entonces
						Escribir "No tienes inscripciones activas."
					SiNo
						Escribir "Seleccione materia para desinscribirse:"
						Leer idMateria
						Si idMateria<1 O idMateria>totalMaterias Entonces
							Escribir "Opción inválida."
						SiNo
							Si inscripciones[idAlumnoLocal,idMateria] = 1 Entonces
								inscripciones[idAlumnoLocal,idMateria] <- 0
								notas[idAlumnoLocal,idMateria] <- 0
								Escribir "Desinscripción realizada."
							SiNo
								Escribir "No estabas inscripto."
							FinSi
						FinSi
					FinSi
					
				5:
					Escribir "Cerrando sesión de alumno..."
			FinSegun
		SiNo
			Escribir "Cerrando sesión de alumno..."
			op <- 5
		FinSi
		
		Si op <> 5 Entonces
			Escribir "Presione una tecla para continuar..."
			Esperar Tecla
		FinSi
		
	Hasta Que op = 5
FinSubProceso

// ======================= UTILIDADES =======================

// Cambiar contraseña
SubProceso CambiarPassword(contraseñas Por Referencia, idUsuario, debeCambiarPass Por Referencia)
	Definir pass_actual, p1, p2 Como Cadena
	
	Escribir "--- Cambio de Contraseña ---"
	Escribir "Ingrese su contraseña actual:"
	Leer pass_actual
	
	Si contraseñas[idUsuario] = pass_actual Entonces
		Repetir
			Escribir "Nueva contraseña:"
			Leer p1
			Escribir "Confirmar contraseña:"
			Leer p2
			Si p1 <> p2 Entonces
				Escribir "No coinciden."
			FinSi
		Hasta Que p1 = p2
		contraseñas[idUsuario] <- p1
		debeCambiarPass[idUsuario] <- 0
		Escribir "Contraseña actualizada."
	SiNo
		Escribir "La contraseña actual es incorrecta."
	FinSi
	
	Escribir "Presione una tecla para continuar..."
	Esperar Tecla
	Limpiar Pantalla
FinSubProceso

// Borrar materia
SubProceso EliminarMateria(materias Por Referencia, totalMaterias Por Referencia, idMateria, inscripciones Por Referencia, notas Por Referencia, materiaProfesor Por Referencia, totalAlumnos, cupoMateria Por Referencia)
	Definir i Como Entero
	// Limpiar inscripciones y notas de esa materia
	Para i<-1 Hasta totalAlumnos Hacer
		notas[i,idMateria] <- 0
		inscripciones[i,idMateria] <- 0
	FinPara
	materiaProfesor[idMateria] <- 0
	
	// Si no es la última, mover última a la posición borrada
	Si idMateria <> totalMaterias Entonces
		materias[idMateria] <- materias[totalMaterias]
		cupoMateria[idMateria] <- cupoMateria[totalMaterias]
		materiaProfesor[idMateria] <- materiaProfesor[totalMaterias]
		Para i<-1 Hasta totalAlumnos Hacer
			inscripciones[i,idMateria] <- inscripciones[i,totalMaterias]
			notas[i,idMateria] <- notas[i,totalMaterias]
			inscripciones[i,totalMaterias] <- 0
			notas[i,totalMaterias] <- 0
		FinPara
	FinSi
	
	totalMaterias <- totalMaterias - 1
	Escribir "Materia eliminada."
FinSubProceso

// Borrar alumno (limpia inscripciones/notas, elimina usuario asociado, re-mapea y compacta)
SubProceso EliminarAlumno(alumnos Por Referencia, totalAlumnos Por Referencia, idAlumno, inscripciones Por Referencia, notas Por Referencia, totalMaterias, usuarios Por Referencia, totalUsuarios Por Referencia, alumnoUsuarioId Por Referencia, roles Por Referencia, contraseñas Por Referencia, estadoUsuario Por Referencia, intentosFallidos Por Referencia, debeCambiarPass Por Referencia)
	Definir j, k, idUser Como Entero
	// Borrar inscripciones/notas del alumno
	Para j<-1 Hasta totalMaterias Hacer
		inscripciones[idAlumno,j] <- 0
		notas[idAlumno,j] <- 0
	FinPara
	
	// Borrar usuario asociado
	idUser <- alumnoUsuarioId[idAlumno]
	Si idUser > 0 Entonces
		usuarios[idUser] <- usuarios[totalUsuarios]
		contraseñas[idUser] <- contraseñas[totalUsuarios]
		roles[idUser] <- roles[totalUsuarios]
		estadoUsuario[idUser] <- estadoUsuario[totalUsuarios]
		intentosFallidos[idUser] <- intentosFallidos[totalUsuarios]
		debeCambiarPass[idUser] <- debeCambiarPass[totalUsuarios]
		// Actualizar mapa si alguien apuntaba al último usuario
		Para k<-1 Hasta totalAlumnos Hacer
			Si alumnoUsuarioId[k] = totalUsuarios Entonces
				alumnoUsuarioId[k] <- idUser
			FinSi
		FinPara
		totalUsuarios <- totalUsuarios - 1
	FinSi
	
	// Compactar arreglo de alumnos
	Si idAlumno <> totalAlumnos Entonces
		alumnos[idAlumno] <- alumnos[totalAlumnos]
		alumnoUsuarioId[idAlumno] <- alumnoUsuarioId[totalAlumnos]
	FinSi
	totalAlumnos <- totalAlumnos - 1
	
	Escribir "Alumno eliminado."
FinSubProceso

// Borrar profesor (desasigna materias, elimina usuario asociado, re-mapea y compacta)
SubProceso EliminarProfesor(profesores Por Referencia, totalProfesores Por Referencia, idProfesor, materiaProfesor Por Referencia, totalMaterias, usuarios Por Referencia, totalUsuarios Por Referencia, profesorUsuarioId Por Referencia, roles Por Referencia, contraseñas Por Referencia, estadoUsuario Por Referencia, intentosFallidos Por Referencia, debeCambiarPass Por Referencia)
	Definir j, k, idUser Como Entero
	// Desasignar materias dictadas por el profesor
	Para j<-1 Hasta totalMaterias Hacer
		Si materiaProfesor[j] = idProfesor Entonces
			materiaProfesor[j] <- 0
		FinSi
	FinPara
	
	// Borrar usuario asociado
	idUser <- profesorUsuarioId[idProfesor]
	Si idUser > 0 Entonces
		usuarios[idUser] <- usuarios[totalUsuarios]
		contraseñas[idUser] <- contraseñas[totalUsuarios]
		roles[idUser] <- roles[totalUsuarios]
		estadoUsuario[idUser] <- estadoUsuario[totalUsuarios]
		intentosFallidos[idUser] <- intentosFallidos[totalUsuarios]
		debeCambiarPass[idUser] <- debeCambiarPass[totalUsuarios]
		// Actualizar mapa si alguien apuntaba al último usuario
		Para k<-1 Hasta totalProfesores Hacer
			Si profesorUsuarioId[k] = totalUsuarios Entonces
				profesorUsuarioId[k] <- idUser
			FinSi
		FinPara
		totalUsuarios <- totalUsuarios - 1
	FinSi
	
	// Compactar arreglo de profesores
	Si idProfesor <> totalProfesores Entonces
		profesores[idProfesor] <- profesores[totalProfesores]
		profesorUsuarioId[idProfesor] <- profesorUsuarioId[totalProfesores]
	FinSi
	totalProfesores <- totalProfesores - 1
	
	Escribir "Profesor eliminado."
FinSubProceso

//Buscar nombres y posicion
Funcion id <- BuscarIdUsuario(lista_nombres, total_elementos, nombre_buscar)
	Definir i, id Como Entero
	id <- 0 // Devuelve 0 si el nombre no está en la lista
	i <- 1
	Mientras i <= total_elementos Y id = 0 Hacer
		Si lista_nombres[i] = nombre_buscar Entonces
			id <- i
		FinSi
		i <- i + 1
	FinMientras
FinFuncion
