// ==================================
//  SISTEMA DE GESTION UNIVERSITARIA
// ==================================

Algoritmo Universidad
	// "Base de datos"
	Dimension materias[10], alumnos[10], profesores[10], materiaProfesor[10]
	Dimension inscripciones[10,10], notas[10,10]
	Dimension usuarios[30], contraseñas[30], roles[30] // 1=Admin,2=Profesor,3=Alumno
	Dimension intentosFallidos[30], estadoUsuario[30], debeCambiarPass[30]
	Dimension alumnoUsuarioId[10], profesorUsuarioId[10]
	Dimension cupoMateria[10]
	
	Definir totalMaterias, totalAlumnos, totalProfesores, totalUsuarios Como Entero
	Definir rolActual, idUsuarioActual Como Entero
	Definir salirPrograma Como Logico
	salirPrograma <- Falso
	
	// Inicializar sistema
	InicializarDatos(materias, totalMaterias, usuarios, contraseñas, roles, totalUsuarios, intentosFallidos, estadoUsuario, debeCambiarPass, alumnos, profesores, totalAlumnos, totalProfesores, alumnoUsuarioId, profesorUsuarioId, cupoMateria, inscripciones, notas, materiaProfesor)
	
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
	
	MostrarBarra
	Escribir "Programa finalizado."
FinAlgoritmo


// ======================= UTILIDADES VISUALES =======================
SubProceso MostrarBarra
	Escribir "============================================================"
FinSubProceso

SubProceso MostrarTitulo (texto)
	MostrarBarra
	Escribir texto
	MostrarBarra
FinSubProceso

SubProceso Pausa
	Escribir "Presione una tecla para continuar..."
	Esperar Tecla
FinSubProceso



// ======================= INICIALIZACION =======================
SubProceso InicializarDatos(materias Por Referencia, totalMaterias Por Referencia, usuarios Por Referencia, contraseñas Por Referencia, roles Por Referencia, totalUsuarios Por Referencia, intentosFallidos Por Referencia, estadoUsuario Por Referencia, debeCambiarPass Por Referencia, alumnos Por Referencia, profesores Por Referencia, totalAlumnos Por Referencia, totalProfesores Por Referencia, alumnoUsuarioId Por Referencia, profesorUsuarioId Por Referencia, cupoMateria Por Referencia, inscripciones Por Referencia, notas Por Referencia, materiaProfesor Por Referencia)
	totalUsuarios <- 3
	totalMaterias <- 3
	totalAlumnos <- 0
	totalProfesores <- 0
	
	Para i <- 1 Hasta 10 Hacer
		alumnoUsuarioId[i] <- 0
		profesorUsuarioId[i] <- 0
	FinPara
	
	materias[1] <- "Programacion"
	materias[2] <- "Matematica"
	materias[3] <- "Algoritmos"
	cupoMateria[1] <- 30
	cupoMateria[2] <- 40
	cupoMateria[3] <- 35
	
	usuarios[1] <- "admin"
	contraseñas[1] <- "1234"
	roles[1] <- 1
	
	usuarios[2] <- "prof"
	contraseñas[2] <- "1234"
	roles[2] <- 2
	
	usuarios[3] <- "alum"
	contraseñas[3] <- "1234"
	roles[3] <- 3
	
	Para i <- 1 Hasta 30 Hacer
		intentosFallidos[i] <- 0
		estadoUsuario[i] <- 1
		debeCambiarPass[i] <- 0
	FinPara
	
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
	
	// Profesor base
	Si roles[2] = 2 Entonces
		totalProfesores <- totalProfesores + 1
		profesores[totalProfesores] <- usuarios[2]
		profesorUsuarioId[totalProfesores] <- 2
	FinSi
	
	// Alumno base
	Si roles[3] = 3 Entonces
		totalAlumnos <- totalAlumnos + 1
		alumnos[totalAlumnos] <- usuarios[3]
		alumnoUsuarioId[totalAlumnos] <- 3
	FinSi
FinSubProceso



// ======================= LOGIN =======================
SubProceso Login(usuarios, contraseñas, roles, totalUsuarios, intentosFallidos Por Referencia, estadoUsuario Por Referencia, idUsuarioActual Por Referencia, rolActual Por Referencia, salir Por Referencia, debeCambiarPass Por Referencia)
	Definir user, pass Como Cadena
	Definir encontrado Como Logico
	Definir id_temporal Como Entero
	encontrado <- Falso
	
	Repetir
		Limpiar Pantalla
		MostrarTitulo("SISTEMA DE GESTION UNIVERSITARIA")
		Escribir "INICIO DE SESION"
		MostrarBarra
		Escribir "Usuario (0 para salir): "
		Leer user
		
		Si user = "0" Entonces
			salir <- Verdadero
		SiNo
			id_temporal <- BuscarIdUsuario(usuarios, totalUsuarios, user)
			
			Si id_temporal = 0 Entonces
				Escribir "Usuario no existe."
				Pausa
			SiNo
				Si estadoUsuario[id_temporal] = 0 Entonces
					Escribir "ACCESO DENEGADO: El usuario está bloqueado."
					Pausa
				SiNo
					Escribir "Contraseña:"
					Leer pass
					
					Si contraseñas[id_temporal] = pass Entonces
						Escribir "Bienvenido ", usuarios[id_temporal]
						encontrado <- Verdadero
						rolActual <- roles[id_temporal]
						idUsuarioActual <- id_temporal
						intentosFallidos[id_temporal] <- 0
						
						Si debeCambiarPass[id_temporal] = 1 Entonces
							Escribir "Debes cambiar tu contraseña antes de continuar."
							CambiarPassword(contraseñas, idUsuarioActual, debeCambiarPass)
						FinSi
						
						Pausa
					SiNo
						intentosFallidos[id_temporal] <- intentosFallidos[id_temporal] + 1
						Escribir "Contraseña incorrecta. Intento ", intentosFallidos[id_temporal], " de 3."
						Si intentosFallidos[id_temporal] >= 3 Entonces
							estadoUsuario[id_temporal] <- 0
							Escribir "Ha superado el limite de intentos. El usuario ha sido bloqueado."
						FinSi
						Pausa
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
		Limpiar Pantalla
		MostrarTitulo("PANEL DEL ADMINISTRADOR")
		Escribir "1. Crear materia"
		Escribir "2. Crear alumno"
		Escribir "3. Crear profesor"
		Escribir "4. Asignar profesor a materia"
		Escribir "5. Modificar datos"
		Escribir "6. Ver estadísticas (texto)"
		Escribir "7. Ver estadísticas gráficas"
		Escribir "8. Buscar (alumno o materia)"
		Escribir "9. Gestionar usuarios"
		Escribir "10. Eliminar registros"
		Escribir "11. Reporte General del Sistema"
		Escribir "0. Salir"
		Escribir Sin Saltar "Opcion: "
		Leer op
		Limpiar Pantalla
		
		Segun op Hacer
			1:
				MostrarTitulo("CREAR MATERIA")
				Si totalMaterias < 10 Entonces
					Escribir "Nombre de la nueva materia:"
					Leer nuevaMateria
					totalMaterias <- totalMaterias + 1
					materias[totalMaterias] <- nuevaMateria
					Escribir "Cupo maximo:"
					Leer cupoMateria[totalMaterias]
					Escribir "Materia creada."
				SiNo
					Escribir "No se pueden agregar mas materias."
				FinSi
				Pausa
				
			2:
				MostrarTitulo("CREAR ALUMNO")
				Si totalAlumnos < 10 Entonces
					Escribir "Nombre del nuevo alumno (usuario):"
					Leer nuevoAlumno
					id_existente <- BuscarIdUsuario(usuarios, totalUsuarios, nuevoAlumno)
					Si id_existente <> 0 Entonces
						Escribir "Ese usuario ya existe."
					SiNo
						totalAlumnos <- totalAlumnos + 1
						alumnos[totalAlumnos] <- nuevoAlumno
						totalUsuarios <- totalUsuarios + 1
						usuarios[totalUsuarios] <- nuevoAlumno
						Escribir "Contraseña temporal:"
						Leer pass
						contraseñas[totalUsuarios] <- pass
						roles[totalUsuarios] <- 3
						debeCambiarPass[totalUsuarios] <- 1
						alumnoUsuarioId[totalAlumnos] <- totalUsuarios
						Escribir "Alumno creado."
					FinSi
				SiNo
					Escribir "No se pueden agregar mas alumnos."
				FinSi
				Pausa
				
			3:
				MostrarTitulo("CREAR PROFESOR")
				Si totalProfesores < 10 Entonces
					Escribir "Nombre del nuevo profesor (usuario):"
					Leer nuevoProfesor
					id_existente <- BuscarIdUsuario(usuarios, totalUsuarios, nuevoProfesor)
					Si id_existente <> 0 Entonces
						Escribir "El nombre de usuario ", nuevoProfesor, " ya existe."
					SiNo
						totalProfesores <- totalProfesores + 1
						profesores[totalProfesores] <- nuevoProfesor
						totalUsuarios <- totalUsuarios + 1
						usuarios[totalUsuarios] <- nuevoProfesor
						Escribir "Contraseña temporal:"
						Leer pass
						contraseñas[totalUsuarios] <- pass
						roles[totalUsuarios] <- 2
						debeCambiarPass[totalUsuarios] <- 1
						profesorUsuarioId[totalProfesores] <- totalUsuarios
						Escribir "Profesor creado con exito."
					FinSi
				SiNo
					Escribir "No se pueden agregar mas profesores."
				FinSi
				Pausa
				
			4:
				MostrarTitulo("ASIGNAR PROFESOR A MATERIA")
				Si totalMaterias > 0 Y totalProfesores > 0 Entonces
					Escribir "Seleccione la materia:"
					Para i <- 1 Hasta totalMaterias Hacer
						Escribir i, ". ", materias[i]
					FinPara
					Leer idMateria
					Si idMateria < 1 O idMateria > totalMaterias Entonces
						Escribir "Opcion no valida."
					SiNo
						Escribir "Seleccione el profesor:"
						Para i <- 1 Hasta totalProfesores Hacer
							Escribir i, ". ", profesores[i]
						FinPara
						Leer idProfesor
						Si idProfesor < 1 O idProfesor > totalProfesores Entonces
							Escribir "Opcion no valida."
						SiNo
							materiaProfesor[idMateria] <- idProfesor
							Escribir "Profesor asignado."
						FinSi
					FinSi
				SiNo
					Escribir "Debe crear materias y profesores primero."
				FinSi
				Pausa
				
			5:
				Repetir
					Limpiar Pantalla
					MostrarTitulo("MODIFICAR DATOS")
					Escribir "1. Cambiar nombre de Alumno"
					Escribir "2. Cambiar nombre de Materia"
					Escribir "3. Volver"
					Leer opcionModificar
					Segun opcionModificar Hacer
						1:
							Si totalAlumnos = 0 Entonces
								Escribir "No hay alumnos."
							SiNo
								Escribir "Seleccione alumno:"
								Para i <- 1 Hasta totalAlumnos Hacer
									Escribir i, ". ", alumnos[i]
								FinPara
								Leer idModificar
								Si idModificar >= 1 Y idModificar <= totalAlumnos Entonces
									Escribir "Nuevo nombre para ", alumnos[idModificar], ":"
									Leer nuevoNombre
									alumnos[idModificar] <- nuevoNombre
									usuarios[ alumnoUsuarioId[idModificar] ] <- nuevoNombre
									Escribir "Nombre actualizado."
								SiNo
									Escribir "Opcion no valida."
								FinSi
							FinSi
							Pausa
						2:
							Si totalMaterias = 0 Entonces
								Escribir "No hay materias."
							SiNo
								Escribir "Seleccione materia:"
								Para i <- 1 Hasta totalMaterias Hacer
									Escribir i, ". ", materias[i]
								FinPara
								Leer idModificar
								Si idModificar >= 1 Y idModificar <= totalMaterias Entonces
									Escribir "Nuevo nombre para ", materias[idModificar], ":"
									Leer nuevoNombre
									materias[idModificar] <- nuevoNombre
									Escribir "Materia actualizada."
								SiNo
									Escribir "Opcion no valida."
								FinSi
							FinSi
							Pausa
					FinSegun
				Hasta Que opcionModificar = 3
				
			6:
				MostrarTitulo("ESTADISTICAS")
				Escribir "Materia                    | Inscriptos | Cupo"
				Escribir "------------------------------------------------"
				Para j <- 1 Hasta totalMaterias Hacer
					cont <- 0
					Para i <- 1 Hasta totalAlumnos Hacer
						Si inscripciones[i,j] = 1 Entonces
							cont <- cont + 1
						FinSi
					FinPara
					Escribir materias[j], " | ", cont, " | ", cupoMateria[j]
				FinPara
				maxCant <- -1
				idTop <- 0
				Para j <- 1 Hasta totalMaterias Hacer
					cont <- 0
					Para i <- 1 Hasta totalAlumnos Hacer
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
					Escribir "Materia con mas inscriptos: ", materias[idTop], " (", maxCant, ")"
				FinSi
				Escribir "Alumnos sin inscripcion:"
				ninguno <- Verdadero
				Para i <- 1 Hasta totalAlumnos Hacer
					tiene <- Falso
					Para j <- 1 Hasta totalMaterias Hacer
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
					Escribir "(Todos tienen al menos una inscripcion)"
				FinSi
				Pausa
				
			7:
				MostrarTitulo("ESTADISTICAS GRAFICAS")
				MostrarEstadisticasGraficas(materias, inscripciones, totalMaterias, totalAlumnos)
				Pausa
				
			8:
				MostrarTitulo("BUSCADOR")
				Escribir "1. Buscar alumno"
				Escribir "2. Buscar materia"
				Escribir "3. Volver"
				Leer opcionModificar
				Segun opcionModificar Hacer
					1: 
						BuscarAlumno(alumnos, totalAlumnos)
					2:
						BuscarMateria(materias, totalMaterias)
				FinSegun
				
			9:
				MostrarTitulo("GESTION DE USUARIOS")
				Para i <- 1 Hasta totalUsuarios Hacer
					Escribir Sin Saltar i, ". ", usuarios[i]
					Si estadoUsuario[i] = 1 Entonces
						Escribir " (Activo)"
					SiNo
						Escribir " (Bloqueado)"
					FinSi
				FinPara
				Escribir "Seleccione un usuario (0 para cancelar):"
				Leer idModificar
				Si idModificar > 0 Y idModificar <= totalUsuarios Entonces
					Si estadoUsuario[idModificar] = 1 Entonces
						estadoUsuario[idModificar] <- 0
						Escribir "Usuario bloqueado."
					SiNo
						estadoUsuario[idModificar] <- 1
						intentosFallidos[idModificar] <- 0
						Escribir "Usuario desbloqueado."
					FinSi
				FinSi
				Pausa
				
			10:
				MostrarTitulo("ELIMINAR REGISTROS")
				Escribir "1. Eliminar Materia"
				Escribir "2. Eliminar Alumno"
				Escribir "3. Eliminar Profesor"
				Escribir "4. Volver"
				Leer opcionModificar
				Segun opcionModificar Hacer
					1:
						Si totalMaterias = 0 Entonces
							Escribir "No hay materias."
						SiNo
							Escribir "Seleccione materia:"
							Para i <- 1 Hasta totalMaterias Hacer
								Escribir i, ". ", materias[i]
							FinPara
							Leer idMateria
							Si idMateria >= 1 Y idMateria <= totalMaterias Entonces
								Escribir "Seguro? (S/N)"
								Leer conf
								Si conf = "S" O conf = "s" Entonces
									EliminarMateria(materias, totalMaterias, idMateria, inscripciones, notas, materiaProfesor, totalAlumnos, cupoMateria)
								SiNo
									Escribir "Operacion cancelada."
								FinSi
							FinSi
						FinSi
						Pausa
						
					2:
						Si totalAlumnos = 0 Entonces
							Escribir "No hay alumnos."
						SiNo
							Escribir "Seleccione alumno:"
							Para i <- 1 Hasta totalAlumnos Hacer
								Escribir i, ". ", alumnos[i]
							FinPara
							Leer idModificar
							Si idModificar >= 1 Y idModificar <= totalAlumnos Entonces
								Escribir "Seguro? (S/N)"
								Leer conf
								Si conf = "S" O conf = "s" Entonces
									EliminarAlumno(alumnos, totalAlumnos, idModificar, inscripciones, notas, totalMaterias, usuarios, totalUsuarios, alumnoUsuarioId, roles, contraseñas, estadoUsuario, intentosFallidos, debeCambiarPass)
								SiNo
									Escribir "Operacion cancelada."
								FinSi
							FinSi
						FinSi
						Pausa
						
					3:
						Si totalProfesores = 0 Entonces
							Escribir "No hay profesores."
						SiNo
							Escribir "Seleccione profesor:"
							Para i <- 1 Hasta totalProfesores Hacer
								Escribir i, ". ", profesores[i]
							FinPara
							Leer idModificar
							Si idModificar >= 1 Y idModificar <= totalProfesores Entonces
								Escribir "Seguro? (S/N)"
								Leer conf
								Si conf = "S" O conf = "s" Entonces
									EliminarProfesor(profesores, totalProfesores, idModificar, materiaProfesor, totalMaterias, usuarios, totalUsuarios, profesorUsuarioId, roles, contraseñas, estadoUsuario, intentosFallidos, debeCambiarPass)
								SiNo
									Escribir "Operacion cancelada."
								FinSi
							FinSi
						FinSi
						Pausa
				FinSegun
				
			11:
				ReporteGeneral(alumnos, totalAlumnos, profesores, totalProfesores, materias, totalMaterias, inscripciones, notas)
			0:
				Escribir "Cerrando sesion..."
				Pausa
			De Otro Modo:
				Escribir "Opcion no valida."
				Pausa
		FinSegun
	Hasta Que op = 0
FinSubProceso



// ======================= PROFESOR =======================
SubProceso MenuProfesor(materias, alumnos, profesores, materiaProfesor, notas Por Referencia, inscripciones, totalMaterias, totalAlumnos, totalProfesores, idUsuarioLogueado, usuarios, contraseñas Por Referencia, totalUsuarios, debeCambiarPass Por Referencia)
	Definir op, i, cont, opcionMateria, idMateria, idProfesorLocal, nota Como Entero
	Dimension listaMaterias[10]
	
	idProfesorLocal <- BuscarIdUsuario(profesores, totalProfesores, usuarios[idUsuarioLogueado])
	
	Repetir
		Limpiar Pantalla
		MostrarTitulo("MENU PROFESOR")
		Escribir "Usuario: ", usuarios[idUsuarioLogueado]
		MostrarBarra
		Escribir "1. Cargar notas"
		Escribir "2. Ver mis materias (con promedios)"
		Escribir "3. Ver pendientes de nota"
		Escribir "4. Ver porcentaje de aprobacion"
		Escribir "5. Resumen de notas (max/min/prom)"
		Escribir "6. Cambiar contraseña"
		Escribir "7. Salir"
		Leer op
		Limpiar Pantalla
		
		Si idProfesorLocal > 0 Entonces
			Segun op Hacer
				1:
					MostrarTitulo("CARGAR NOTAS")
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
						Escribir "Seleccione materia:"
						Para i <- 1 Hasta cont Hacer
							Escribir i, ". ", materias[listaMaterias[i]]
						FinPara
						Leer opcionMateria
						Si opcionMateria < 1 O opcionMateria > cont Entonces
							Escribir "Opcion invalida."
						SiNo
							idMateria <- listaMaterias[opcionMateria]
							Escribir "Alumnos inscriptos en ", materias[idMateria], ":"
							Para i <- 1 Hasta totalAlumnos Hacer
								Si inscripciones[i,idMateria] = 1 Entonces
									Repetir
										Escribir "Nota (0 a 10) para ", alumnos[i], ":"
										Leer nota
									Hasta Que nota >= 0 Y nota <= 10
									notas[i,idMateria] <- nota
								FinSi
							FinPara
							Escribir "Notas cargadas."
						FinSi
					FinSi
					Pausa
					
				2:
					MostrarTitulo("MIS MATERIAS")
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
						Escribir "Seleccione materia:"
						Para i <- 1 Hasta cont Hacer
							Escribir i, ". ", materias[listaMaterias[i]]
						FinPara
						Leer opcionMateria
						Si opcionMateria < 1 O opcionMateria > cont Entonces
							Escribir "Opcion invalida."
						SiNo
							idMateria <- listaMaterias[opcionMateria]
							MostrarTitulo("ALUMNOS EN")
							Escribir materias[idMateria]
							MostrarBarra
							VerAlumnosConPromedio(idMateria, alumnos, inscripciones, notas, totalAlumnos)
						FinSi
					FinSi
					Pausa
					
				3:
					MostrarTitulo("PENDIENTES DE NOTA")
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
						Escribir "Seleccione materia:"
						Para i <- 1 Hasta cont Hacer
							Escribir i, ". ", materias[listaMaterias[i]]
						FinPara
						Leer opcionMateria
						Si opcionMateria < 1 O opcionMateria > cont Entonces
							Escribir "Opcion invalida."
						SiNo
							idMateria <- listaMaterias[opcionMateria]
							VerPendientesDeNota(idMateria, alumnos, inscripciones, notas, totalAlumnos, materias)
						FinSi
					FinSi
					Pausa
					
				4:
					VerPorcentajeAprobacion(materiaProfesor, notas, inscripciones, materias, totalMaterias, totalAlumnos, idProfesorLocal)
					
				5:
					VerResumenNotasMateria(materiaProfesor, materias, notas, inscripciones, totalMaterias, totalAlumnos, idProfesorLocal)
					
				6:
					CambiarPassword(contraseñas, idUsuarioLogueado, debeCambiarPass)
					
				7:
					Escribir "Cerrando sesion de profesor..."
					Pausa
			FinSegun
		SiNo
			Escribir "Cerrando sesion de profesor..."
			op <- 7
		FinSi
	Hasta Que op = 7
FinSubProceso



SubProceso VerAlumnosConPromedio(idMateria, alumnos, inscripciones, notas, totalAlumnos)
	Definir i Como Entero
	Definir suma Como Real
	Definir cant Como Entero
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
		MostrarBarra
		Escribir "Promedio de la materia: ", suma / cant
		MostrarBarra
	SiNo
		Escribir "No hay alumnos con nota."
	FinSi
FinSubProceso

SubProceso VerPendientesDeNota(idMateria, alumnos, inscripciones, notas, totalAlumnos, materias)
	Definir i Como Entero
	Definir hay Como Logico
	hay <- Falso
	Escribir "Alumnos sin nota en: ", materias[idMateria]
	Para i <- 1 Hasta totalAlumnos Hacer
		Si inscripciones[i,idMateria] = 1 Y notas[i,idMateria] = 0 Entonces
			Escribir "- ", alumnos[i]
			hay <- Verdadero
		FinSi
	FinPara
	Si NO hay Entonces
		Escribir "(No hay pendientes)"
	FinSi
FinSubProceso

SubProceso VerPorcentajeAprobacion(materiaProfesor, notas, inscripciones, materias, totalMaterias, totalAlumnos, idProfesor)
	Definir j, i, aprobados, totalInscritos Como Entero
	MostrarTitulo("PORCENTAJE DE APROBACION")
	Para j <- 1 Hasta totalMaterias Hacer
		Si materiaProfesor[j] = idProfesor Entonces
			aprobados <- 0
			totalInscritos <- 0
			Para i <- 1 Hasta totalAlumnos Hacer
				Si inscripciones[i,j] = 1 Entonces
					totalInscritos <- totalInscritos + 1
					Si notas[i,j] >= 6 Entonces
						aprobados <- aprobados + 1
					FinSi
				FinSi
			FinPara
			Si totalInscritos > 0 Entonces
				Escribir materias[j], ": ", aprobados, "/", totalInscritos, " aprobados (", (aprobados * 100) / totalInscritos, "%)"
			SiNo
				Escribir materias[j], ": sin alumnos inscriptos."
			FinSi
		FinSi
	FinPara
	Pausa
FinSubProceso

SubProceso VerResumenNotasMateria(materiaProfesor, materias, notas, inscripciones, totalMaterias, totalAlumnos, idProfesor)
	Definir j, i, max, min, suma, cant Como Entero
	MostrarTitulo("RESUMEN DE NOTAS")
	Para j <- 1 Hasta totalMaterias Hacer
		Si materiaProfesor[j] = idProfesor Entonces
			max <- -1
			min <- 11
			suma <- 0
			cant <- 0
			Para i <- 1 Hasta totalAlumnos Hacer
				Si inscripciones[i,j] = 1 Y notas[i,j] > 0 Entonces
					Si notas[i,j] > max Entonces
						max <- notas[i,j]
					FinSi
					Si notas[i,j] < min Entonces
						min <- notas[i,j]
					FinSi
					suma <- suma + notas[i,j]
					cant <- cant + 1
				FinSi
			FinPara
			Si cant > 0 Entonces
				Escribir materias[j], ": Max=", max, " | Min=", min, " | Prom=", suma / cant
			SiNo
				Escribir materias[j], ": sin notas cargadas."
			FinSi
		FinSi
	FinPara
	Pausa
FinSubProceso



// ======================= ALUMNO =======================
SubProceso MenuAlumno(materias, alumnos, notas, inscripciones Por Referencia, totalMaterias, totalAlumnos Por Referencia, idUsuarioLogueado, usuarios, contraseñas Por Referencia, totalUsuarios, cupoMateria, debeCambiarPass Por Referencia, alumnoUsuarioId Por Referencia)
	Definir op, i, j, idMateria, cant Como Entero
	Definir suma, promedio Como Real
	Definir idAlumnoLocal Como Entero
	Definir hay Como Logico
	
	idAlumnoLocal <- BuscarIdUsuario(alumnos, totalAlumnos, usuarios[idUsuarioLogueado])
	
	Repetir
		Limpiar Pantalla
		MostrarTitulo("MENU ESTUDIANTE")
		Escribir "Usuario: ", usuarios[idUsuarioLogueado]
		MostrarBarra
		Escribir "1. Inscribirse en materia"
		Escribir "2. Ver mis notas y promedio"
		Escribir "3. Cambiar contraseña"
		Escribir "4. Desinscribirse de materia"
		Escribir "5. Simular promedio"
		Escribir "6. Ver materias sin nota"
		Escribir "7. Ver estado de aprobación"
		Escribir "8. Ver progreso total"
		Escribir "9. Salir"
		Leer op
		Limpiar Pantalla
		
		Si idAlumnoLocal > 0 Entonces
			Segun op Hacer
				1:
					MostrarTitulo("INSCRIPCION A MATERIA")
					Si totalMaterias = 0 Entonces
						Escribir "No hay materias disponibles."
					SiNo
						Para i <- 1 Hasta totalMaterias Hacer
							Escribir i, ". ", materias[i]
						FinPara
						Escribir "Seleccione materia:"
						Leer idMateria
						Si idMateria < 1 O idMateria > totalMaterias Entonces
							Escribir "Opcion invalida."
						SiNo
							Si inscripciones[idAlumnoLocal,idMateria] = 1 Entonces
								Escribir "Ya estas inscripto en esa materia."
							SiNo
								cant <- 0
								Para i <- 1 Hasta totalAlumnos Hacer
									Si inscripciones[i,idMateria] = 1 Entonces
										cant <- cant + 1
									FinSi
								FinPara
								Si cant >= cupoMateria[idMateria] Entonces
									Escribir "Cupo completo."
								SiNo
									inscripciones[idAlumnoLocal,idMateria] <- 1
									Escribir "Inscripcion exitosa."
								FinSi
							FinSi
						FinSi
					FinSi
					Pausa
					
				2:
					MostrarTitulo("MIS NOTAS")
					suma <- 0
					cant <- 0
					Para j <- 1 Hasta totalMaterias Hacer
						Si inscripciones[idAlumnoLocal,j] = 1 Entonces
							Escribir materias[j], ":"
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
						MostrarBarra
						Escribir "Tu promedio general: ", promedio
						MostrarBarra
						Si promedio >= 8 Entonces
							Escribir "Felicitaciones: sos alumno destacado."
						FinSi
					SiNo
						Escribir "Aun no tienes notas cargadas."
					FinSi
					Pausa
					
				3:
					CambiarPassword(contraseñas, idUsuarioLogueado, debeCambiarPass)
					
				4:
					MostrarTitulo("DESINSCRIPCION")
					Escribir "Materias en las que estas inscripto:"
					hay <- Falso
					Para j <- 1 Hasta totalMaterias Hacer
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
						Si idMateria < 1 O idMateria > totalMaterias Entonces
							Escribir "Opcion invalida."
						SiNo
							Si inscripciones[idAlumnoLocal,idMateria] = 1 Entonces
								inscripciones[idAlumnoLocal,idMateria] <- 0
								notas[idAlumnoLocal,idMateria] <- 0
								Escribir "Desinscripcion realizada."
							SiNo
								Escribir "No estabas inscripto."
							FinSi
						FinSi
					FinSi
					Pausa
					
				5:
					SimularPromedio(idAlumnoLocal, materias, inscripciones, notas, totalMaterias)
					
				6:
					VerMateriasSinNota(idAlumnoLocal, materias, inscripciones, notas, totalMaterias)
					
				7:
					VerEstadoAprobacion(idAlumnoLocal, materias, notas, inscripciones, totalMaterias)
					
				8:
					VerProgresoCarrera(idAlumnoLocal, materias, notas, inscripciones, totalMaterias)
					
				9:
					Escribir "Cerrando sesion de alumno..."
					Pausa
			FinSegun
		SiNo
			Escribir "Cerrando sesion de alumno..."
			op <- 9
		FinSi
	Hasta Que op = 9
FinSubProceso



// ======= FUNCIONALIDADES =======
SubProceso ReporteGeneral(alumnos, totalAlumnos, profesores, totalProfesores, materias, totalMaterias, inscripciones, notas)
    Definir i, j Como Entero
    Definir totalInscripciones, cantNotas Como Entero
    Definir sumaNotas Como Real
    Definir promedioGlobal Como Real
    Definir hayMateriaSinInscripto Como Logico
    Definir tieneInscripto Como Logico
	
    totalInscripciones <- 0
    sumaNotas <- 0
    cantNotas <- 0
	
    // contar inscripciones y notas reales
    Para i <- 1 Hasta totalAlumnos Hacer
        Para j <- 1 Hasta totalMaterias Hacer
            Si inscripciones[i,j] = 1 Entonces
                totalInscripciones <- totalInscripciones + 1
                Si notas[i,j] > 0 Entonces
                    sumaNotas <- sumaNotas + notas[i,j]
                    cantNotas <- cantNotas + 1
                FinSi
            FinSi
        FinPara
    FinPara
	
    Si cantNotas > 0 Entonces
        promedioGlobal <- sumaNotas / cantNotas
    SiNo
        promedioGlobal <- 0
    FinSi
	
    MostrarTitulo("REPORTE GENERAL DEL SISTEMA")
    Escribir "Total de alumnos: ", totalAlumnos
    Escribir "Total de profesores: ", totalProfesores
    Escribir "Total de materias: ", totalMaterias
    Escribir "Total de inscripciones activas: ", totalInscripciones
    Escribir "Promedio global de todas las notas cargadas: ", promedioGlobal
    Escribir ""
    Escribir "Materias sin inscriptos:"
    hayMateriaSinInscripto <- Falso
	
    Para j <- 1 Hasta totalMaterias Hacer
        tieneInscripto <- Falso
        Para i <- 1 Hasta totalAlumnos Hacer
            Si inscripciones[i,j] = 1 Entonces
                tieneInscripto <- Verdadero
            FinSi
        FinPara
        Si NO tieneInscripto Entonces
            Escribir "- ", materias[j]
            hayMateriaSinInscripto <- Verdadero
        FinSi
    FinPara
	
    Si NO hayMateriaSinInscripto Entonces
        Escribir "(Todas las materias tienen al menos un alumno)"
    FinSi
	
    Pausa
FinSubProceso

SubProceso SimularPromedio(idAlumno, materias, inscripciones, notas, totalMaterias)
	Definir j, cant Como Entero
	Definir suma, notaSimulada, promedioSim Como Real
	Definir materiaElegida Como Entero
	Definir valido Como Logico
	
	// promedio actual
	suma <- 0
	cant <- 0
	Para j <- 1 Hasta totalMaterias Hacer
		Si inscripciones[idAlumno,j] = 1 Y notas[idAlumno,j] > 0 Entonces
			suma <- suma + notas[idAlumno,j]
			cant <- cant + 1
		FinSi
	FinPara
	
	Escribir "Materias para simular:"
	Para j <- 1 Hasta totalMaterias Hacer
		Si inscripciones[idAlumno,j] = 1 Entonces
			Escribir j, ". ", materias[j]
		FinSi
	FinPara
	Escribir "Seleccione materia:"
	Leer materiaElegida
	
	valido <- Verdadero
	
	Si materiaElegida < 1 O materiaElegida > totalMaterias Entonces
		Escribir "Materia inexistente."
		valido <- Falso
	SiNo
		Si inscripciones[idAlumno,materiaElegida] = 0 Entonces
			Escribir "No estas inscripto en esa materia."
			valido <- Falso
		FinSi
	FinSi
	
	Si valido Entonces
		Repetir
			Escribir "Nota que crees que vas a sacar (1 a 10):"
			Leer notaSimulada
			Si notaSimulada < 1 O notaSimulada > 10 Entonces
				Escribir "Valor inválido. Debe ser entre 1 y 10."
			FinSi
		Hasta Que notaSimulada >= 1 Y notaSimulada <= 10
		
		promedioSim <- (suma + notaSimulada) / (cant + 1)
		Escribir "Tu promedio quedaria en: ", promedioSim
	FinSi
	
	Pausa
FinSubProceso

SubProceso VerMateriasSinNota(idAlumno, materias, inscripciones, notas, totalMaterias)
	Definir j Como Entero
	Definir hay Como Logico
	hay <- Falso
	MostrarTitulo("MATERIAS SIN NOTA")
	Para j <- 1 Hasta totalMaterias Hacer
		Si inscripciones[idAlumno,j] = 1 Y notas[idAlumno,j] = 0 Entonces
			Escribir "- ", materias[j]
			hay <- Verdadero
		FinSi
	FinPara
	Si NO hay Entonces
		Escribir "No tenes materias pendientes de nota."
	FinSi
	Pausa
FinSubProceso

SubProceso VerEstadoAprobacion(idAlumno, materias, notas, inscripciones, totalMaterias)
	Definir j Como Entero
	MostrarTitulo("ESTADO DE APROBACION")
	Para j <- 1 Hasta totalMaterias Hacer
		Si inscripciones[idAlumno,j] = 1 Entonces
			Si notas[idAlumno,j] >= 6 Entonces
				Escribir materias[j], ": ", notas[idAlumno,j], "  Aprobado"
			SiNo
				Si notas[idAlumno,j] > 0 Entonces
					Escribir materias[j], ": ", notas[idAlumno,j], "  Reprobado"
				SiNo
					Escribir materias[j], ": (sin nota cargada)"
				FinSi
			FinSi
		FinSi
	FinPara
	Pausa
FinSubProceso

SubProceso VerProgresoCarrera(idAlumno, materias, notas, inscripciones, totalMaterias)
	Definir j, totalInscriptas, aprobadas Como Entero
	aprobadas <- 0
	totalInscriptas <- 0
	Para j <- 1 Hasta totalMaterias Hacer
		Si inscripciones[idAlumno,j] = 1 Entonces
			totalInscriptas <- totalInscriptas + 1
			Si notas[idAlumno,j] >= 6 Entonces
				aprobadas <- aprobadas + 1
			FinSi
		FinSi
	FinPara
	Si totalInscriptas = 0 Entonces
		Escribir "No estas inscripto en ninguna materia."
	SiNo
		Escribir "Aprobadas: ", aprobadas, "/", totalInscriptas
		Escribir "Te faltan ", totalInscriptas - aprobadas, " para aprobar todas."
	FinSi
	Pausa
FinSubProceso

SubProceso MostrarEstadisticasGraficas(materias, inscripciones, totalMaterias, totalAlumnos)
	Definir i, j, cont, k Como Entero
	Para i <- 1 Hasta totalMaterias Hacer
		cont <- 0
		Para j <- 1 Hasta totalAlumnos Hacer
			Si inscripciones[j,i] = 1 Entonces
				cont <- cont + 1
			FinSi
		FinPara
		Escribir materias[i], ": "
		Escribir Sin Saltar "   "
		Para k <- 1 Hasta cont Hacer
			Escribir Sin Saltar "*"
		FinPara
		Escribir " (", cont, ")"
	FinPara
FinSubProceso

SubProceso BuscarAlumno(alumnos, totalAlumnos)
	Definir nombreBuscado Como Cadena
	Definir i Como Entero
	Definir encontrado Como Logico
	encontrado <- Falso
	Escribir "Ingrese el nombre exacto del alumno:"
	Leer nombreBuscado
	Para i <- 1 Hasta totalAlumnos Hacer
		Si alumnos[i] = nombreBuscado Entonces
			Escribir "Alumno encontrado en posicion ", i
			encontrado <- Verdadero
		FinSi
	FinPara
	Si NO encontrado Entonces
		Escribir "No se encontro el alumno."
	FinSi
	Pausa
FinSubProceso

SubProceso BuscarMateria(materias, totalMaterias)
	Definir nombreBuscado Como Cadena
	Definir i Como Entero
	Definir encontrado Como Logico
	encontrado <- Falso
	Escribir "Ingrese el nombre exacto de la materia:"
	Leer nombreBuscado
	Para i <- 1 Hasta totalMaterias Hacer
		Si materias[i] = nombreBuscado Entonces
			Escribir "Materia encontrada en posicion ", i
			encontrado <- Verdadero
		FinSi
	FinPara
	Si NO encontrado Entonces
		Escribir "No se encontro la materia."
	FinSi
	Pausa
FinSubProceso

SubProceso CambiarPassword(contraseñas Por Referencia, idUsuario, debeCambiarPass Por Referencia)
	Definir pass_actual, p1, p2 Como Cadena
	
	MostrarTitulo("CAMBIO DE CONTRASENA")
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
	
	Pausa
	Limpiar Pantalla
FinSubProceso

SubProceso EliminarMateria(materias Por Referencia, totalMaterias Por Referencia, idMateria, inscripciones Por Referencia, notas Por Referencia, materiaProfesor Por Referencia, totalAlumnos, cupoMateria Por Referencia)
	Definir i Como Entero
	Para i <- 1 Hasta totalAlumnos Hacer
		notas[i,idMateria] <- 0
		inscripciones[i,idMateria] <- 0
	FinPara
	materiaProfesor[idMateria] <- 0
	
	Si idMateria <> totalMaterias Entonces
		materias[idMateria] <- materias[totalMaterias]
		cupoMateria[idMateria] <- cupoMateria[totalMaterias]
		materiaProfesor[idMateria] <- materiaProfesor[totalMaterias]
		Para i <- 1 Hasta totalAlumnos Hacer
			inscripciones[i,idMateria] <- inscripciones[i,totalMaterias]
			notas[i,idMateria] <- notas[i,totalMaterias]
			inscripciones[i,totalMaterias] <- 0
			notas[i,totalMaterias] <- 0
		FinPara
	FinSi
	
	totalMaterias <- totalMaterias - 1
	Escribir "Materia eliminada."
FinSubProceso

SubProceso EliminarAlumno(alumnos Por Referencia, totalAlumnos Por Referencia, idAlumno, inscripciones Por Referencia, notas Por Referencia, totalMaterias, usuarios Por Referencia, totalUsuarios Por Referencia, alumnoUsuarioId Por Referencia, roles Por Referencia, contraseñas Por Referencia, estadoUsuario Por Referencia, intentosFallidos Por Referencia, debeCambiarPass Por Referencia)
	Definir j, k, idUser Como Entero
	
	Para j <- 1 Hasta totalMaterias Hacer
		inscripciones[idAlumno,j] <- 0
		notas[idAlumno,j] <- 0
	FinPara
	
	idUser <- alumnoUsuarioId[idAlumno]
	Si idUser > 0 Entonces
		usuarios[idUser] <- usuarios[totalUsuarios]
		contraseñas[idUser] <- contraseñas[totalUsuarios]
		roles[idUser] <- roles[totalUsuarios]
		estadoUsuario[idUser] <- estadoUsuario[totalUsuarios]
		intentosFallidos[idUser] <- intentosFallidos[totalUsuarios]
		debeCambiarPass[idUser] <- debeCambiarPass[totalUsuarios]
		
		Para k <- 1 Hasta totalAlumnos Hacer
			Si alumnoUsuarioId[k] = totalUsuarios Entonces
				alumnoUsuarioId[k] <- idUser
			FinSi
		FinPara
		
		totalUsuarios <- totalUsuarios - 1
	FinSi
	
	Si idAlumno <> totalAlumnos Entonces
		alumnos[idAlumno] <- alumnos[totalAlumnos]
		alumnoUsuarioId[idAlumno] <- alumnoUsuarioId[totalAlumnos]
	FinSi
	
	totalAlumnos <- totalAlumnos - 1
	Escribir "Alumno eliminado."
FinSubProceso

SubProceso EliminarProfesor(profesores Por Referencia, totalProfesores Por Referencia, idProfesor, materiaProfesor Por Referencia, totalMaterias, usuarios Por Referencia, totalUsuarios Por Referencia, profesorUsuarioId Por Referencia, roles Por Referencia, contraseñas Por Referencia, estadoUsuario Por Referencia, intentosFallidos Por Referencia, debeCambiarPass Por Referencia)
	Definir j, k, idUser Como Entero
	
	Para j <- 1 Hasta totalMaterias Hacer
		Si materiaProfesor[j] = idProfesor Entonces
			materiaProfesor[j] <- 0
		FinSi
	FinPara
	
	idUser <- profesorUsuarioId[idProfesor]
	Si idUser > 0 Entonces
		usuarios[idUser] <- usuarios[totalUsuarios]
		contraseñas[idUser] <- contraseñas[totalUsuarios]
		roles[idUser] <- roles[totalUsuarios]
		estadoUsuario[idUser] <- estadoUsuario[totalUsuarios]
		intentosFallidos[idUser] <- intentosFallidos[totalUsuarios]
		debeCambiarPass[idUser] <- debeCambiarPass[totalUsuarios]
		Para k <- 1 Hasta totalProfesores Hacer
			Si profesorUsuarioId[k] = totalUsuarios Entonces
				profesorUsuarioId[k] <- idUser
			FinSi
		FinPara
		totalUsuarios <- totalUsuarios - 1
	FinSi
	
	Si idProfesor <> totalProfesores Entonces
		profesores[idProfesor] <- profesores[totalProfesores]
		profesorUsuarioId[idProfesor] <- profesorUsuarioId[totalProfesores]
	FinSi
	
	totalProfesores <- totalProfesores - 1
	Escribir "Profesor eliminado."
FinSubProceso

Funcion id <- BuscarIdUsuario(lista_nombres, total_elementos, nombre_buscar)
	Definir i, id Como Entero
	id <- 0
	i <- 1
	Mientras i <= total_elementos Y id = 0 Hacer
		Si lista_nombres[i] = nombre_buscar Entonces
			id <- i
		FinSi
		i <- i + 1
	FinMientras
FinFuncion